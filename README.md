# flextext2html

This XSL is used to generate visualizations from FLEXTEXT files. Some examples can be seen [here](https://inel.corpora.uni-hamburg.de/?page_id=652) and [here](https://inel.corpora.uni-hamburg.de/?page_id=649). The result is not final and further sophistication in the tool is needed if there is will to use it directly with other file formats such as EXB.

## Instructions

Modify the font locations in the XSL, now folder called `fonts` is expected. Also different attributes have to be modified in case the glosses and translations are not in English. In principle it is easy to add elements which would add translations and glosses on other languages.

## Attribution

The XSL was written by Niko Partanen while working in [INEL project](https://inel.corpora.uni-hamburg.de). Visualization uses [Leipzig.js](http://bdchauvette.net/leipzig.js/) JavaScript library created by Benjamin Chauvette. The visualizations with complex scripts work best with fonts such as Charis SIL, which can be downloaded from [here](http://software.sil.org/charis/), and which is released by SIL with SIL Open Font License.
