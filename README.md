## supplemental material to the manuscript:

## Integration of hierarchical levels of scale in tree species distribution models of European beech (*Fagus sylvatica* L.) and silver fir (*Abies alba* Mill.) in mountain forests 

authors:   
Alois SIMON<sup>1,2*</sup>, Klaus KATZENSTEINER<sup>1</sup>, Gudrun WALLENTIN<sup>3</sup>

1 Institute of Forest Ecology, Department of Forest and Soil Sciences, University of Natural Resources and Life Sciences Vienna, 
Vienna, Austria  
2 Department of Forest Planning, Forest Administration Tyrol, Office of the Tyrolean Government, Innsbruck, Austria  
3 Department of Geoinformatics – Z_GIS, University of Salzburg, Salzburg, Austria

*corresponding author   
email: simonalois@web.de  
postal address: Bürgerstraße 36, 6020 Innsbruck, Austria  



Keywords:  
species distribution modelling, cross-scale approach, environmental predictor variables, partitioning effects, soil information, Alpine environment

Highlights:
- The species distribution of silver fir and European beech is modelled with deep neural networks.
- Methods for addressing strong imbalance of absent and present are evaluated. 
- Regional and continental occurrence data and predictor variables are integrated.
- The predictive power of climate, soil, and topographic information is assessed.

<br>
<br>

**Abstract**:<p align="justify">
Taking into account and combining different levels of scale is essential in species distribution models when it comes to the investigation of the environmental niche of a species. The study focuses on two levels of spatial extent, on the one hand the continental level of Europe, and on the other hand the regional level of the federal state of Tyrol in Austria. Mountain forests in the European Alps cover the inner Alpine distribution margins of several tree species and therefore are particularly well-suited to reveal the predictive power of climate, soil, and topographic variables on the shaping of these margins. The potential occurrence of the two investigated tree species, Abies alba and Fagus sylvatica, is an important criterion for the delineation of elevational vegetation zones in forest site classification systems and was modelled with Deep Neural Networks. In the process, we observed a strong imbalance of absence and presence records at the continental level and evaluated different methods to address this issue. The potential predictor variables for species distribution modelling at the different spatial extents were grouped into climate, soil, and topographic information. The combination of the different hierarchical levels of extent and associated spatial resolution was implemented by using the outputs of the continental model as a predictor variable in the regional model. The binary classification of the 30% test dataset showed a True Skill Statistic of 0.73 to 0.76 for the regional level and 0.5 to 0.74 for the continental level, with slightly higher values for F. sylvatica than for A. alba. For both species and extent levels, the climate predictor group showed the greatest contribution (81 to 96 %) to the models’ predictive power. At the regional level, climate was followed by soil and then topographic predictor groups. At the continental level however, topography showed stronger effects than soil information. In most cases, the consideration of soil information along climatic gradients led to an increase in the occurrence probability at the climatic distribution margins. There is evidence that soil conditions are more important in determining the inner Alpine distribution margins for F. sylvatica than for A. alba. To improve species distribution models at the regional level, e.g. in the Alpine area, a focus on soil information is proposed. In general, models which combine continental and regional data are preferable.
</p>
<br>

**Conceptual Diagram:**

<kbd><img src="https://github.com/simonalois/sdm/blob/main/concept/conceptual_diagramm_hierachicalmodelling.jpg" title="Conceptual Diagram" /></kbd>
<br>
<br>
<a rel="license" href="http://creativecommons.org/licenses/by-nc-nd/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-nd/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-nd/4.0/">Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License</a>.
