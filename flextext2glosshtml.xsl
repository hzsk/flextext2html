<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:my="http://www.philol.msu.ru/~languedoc/xml"
    exclude-result-prefixes="#all" version="2.0">

    <!-- Modified after Sasha Arkhipov's stylesheet:

    https://github.com/sarkipo/xsl4interlinear

    Uses Leipzig.js which can be found here:
    http://bdchauvette.net/leipzig.js/
    https://github.com/bdchauvette/leipzig.js/
    -->

    <xsl:output method="html" indent="yes" encoding="utf-8" omit-xml-declaration="no"/>
    <xsl:namespace-alias stylesheet-prefix="#default" result-prefix=""/>

    <xsl:template match="interlinear-text/item[@type='title-abbreviation']">
        <xsl:variable name="filename" select="concat('html/',text(),'.html')"/>

        <xsl:variable name="html_break">
            <br/>
        </xsl:variable>

        <xsl:result-document href="{$filename}">
            <html>

                <head>
                    <link rel="stylesheet" href="../leipzig.min.css"/>
                    <script src="../leipzig.min.js"/>

                    <style>
                        @font-face{
                            font-family:"Charis SIL";
                            src:url("fonts/CharisSILCompact-R.ttf") format('truetype');
                        }

                        @font-face{
                            font-family:"Charis SIL";
                            src:url("fonts/CharisSILCompact-B.ttf") format('truetype');
                            font-weight:bold;
                        }

                        @font-face{
                            font-family:"Charis SIL";
                            src:url("fonts/CharisSILCompact-BI.ttf") format('truetype');
                            font-weight:bold;
                            font-style:italic;
                        }

                        @font-face{
                            font-family:"Charis SIL";
                            src:url("fonts/CharisSILCompact-I.ttf") format('truetype');
                            font-style:italic;
                        }

                        div{
                            font-family:"Charis SIL";
                            /* line-height: 12pt; This can be used to control the line height */
                        }

                        }

                        p{
                            font-family:"Charis SIL";
                        }</style>


                </head>

                <body>

                    <h2>
                        <xsl:value-of
                            select="preceding-sibling::node()[@type='title' and @lang='en']"/>
                    </h2>
                    <p>
                        <xsl:analyze-string select="following-sibling::node()[@type='source' and @lang='en']" regex="/">
                            <xsl:matching-substring>
                                <br />
                                <xsl:value-of select="'&#x0A;'" />
                            </xsl:matching-substring>
                            <xsl:non-matching-substring>
                                <xsl:value-of select="."/>
                            </xsl:non-matching-substring>
                        </xsl:analyze-string>
                    </p>
                    <xsl:for-each select="../paragraphs/paragraph/phrases/phrase">
                        <div>
                            <xsl:attribute name="data-gloss"/>
                            <p>
                                <xsl:for-each-group select="./words/word"
                                    group-starting-with="word[item/@type!='punct' and preceding-sibling::word/item/@type!='punct']">

                                    <xsl:variable name="value">
                                        <xsl:value-of
                                            select="current-group()/item[@type='txt' or @type='punct']"
                                            separator=""/>
                                    </xsl:variable>
                                    <xsl:value-of select="my:cleanup-tx($value)"/>

                                </xsl:for-each-group>
                            </p>

                            <!-- This adds the segmented word elements -->

                            <p>
                                <xsl:for-each-group select=".//word"
                                    group-starting-with="word[item/@type!='punct' and preceding-sibling::word/item/@type!='punct']">

                                    <xsl:variable name="value">
                                        <xsl:value-of
                                            select="current-group()/morphemes/morph/item[@type='cf' and @lang='sel']"
                                            separator=""/>
                                    </xsl:variable>
                                    <xsl:value-of select="my:cleanup-tx($value)"/>

                                </xsl:for-each-group>
                            </p>

                            <!-- This adds the glosses -->

                            <p>
                                <xsl:for-each-group select=".//word"
                                    group-starting-with="word[item/@type!='punct' and preceding-sibling::word/item/@type!='punct']">

                                    <xsl:variable name="value">
                                        <xsl:value-of
                                            select="current-group()/morphemes/morph/item[@type='gls' and @lang='en']"
                                            separator="-"/>
                                    </xsl:variable>
                                    <xsl:value-of select="my:cleanup-tx($value)"/>

                                </xsl:for-each-group>
                            </p>
                            <!-- This adds the translation -->
                            <xsl:for-each select="./item[@type='gls' and @lang='en']">
                                <p>
                                    <xsl:value-of select="."/>
                                </p>
                            </xsl:for-each>
                        </div>
                    </xsl:for-each>

                    <script src="leipzig.min.js"/>
                    <script>
                    document.addEventListener('DOMContentLoaded', function() {
                    Leipzig({ firstLineOrig: true }).gloss();
                    });
                </script>

                    <hr/>
                    <p>Glosses visualized with <a href="http://bdchauvette.net/leipzig.js/"
                            >Leipzig.js</a>.</p>

                </body>
            </html>
        </xsl:result-document>
    </xsl:template>


    <xsl:function name="my:cleanup-tx" as="xs:string">
        <xsl:param name="in" as="xs:string"/>
        <xsl:value-of select="concat($in,' ')"/>
        <!-- attach one space -->
    </xsl:function>

    <xsl:function name="my:cleanup-morph" as="xs:string">
        <xsl:param name="in" as="xs:string"/>
        <xsl:value-of select="replace($in,'-\^0$','')"/>
        <!-- strip final -^0 -->
    </xsl:function>

    <xsl:function name="my:cleanup-gloss" as="xs:string">
        <xsl:param name="in" as="xs:string"/>
        <xsl:value-of select="replace($in,'-(\[.+\])','.$1')"/>
        <!-- put . instead of - before [...] -->
    </xsl:function>

    <xsl:function name="my:cleanup-gloss-tokens" as="xs:string">
        <xsl:param name="in" as="xs:string"/>
        <xsl:value-of select="replace($in,' -','-')"/>
        <!-- tries to put things together -->
    </xsl:function>

    <xsl:function name="my:cleanup-gloss-glosses" as="xs:string">
        <xsl:param name="in" as="xs:string"/>
        <xsl:value-of select="replace($in,' -','-')"/>
        <!-- tries to put things together -->
    </xsl:function>

</xsl:stylesheet>
