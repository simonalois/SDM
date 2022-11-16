## supplemental material to the manuscript:

## Integration of hierarchical levels of extent and scale in tree species distribution models of European beech (*Fagus sylvatica* L.) and silver fir (*Abies alba* Mill.) 

authors:   
Alois SIMON<sup>1,2*</sup>, Klaus KATZENSTEINER<sup>1</sup>, Gudrun WALLENTIN<sup>3</sup>

1 Institute of Forest Ecology, Department of Forest and Soil Sciences, University of Natural Resources and Life Sciences Vienna, 
Vienna, Austria  
2 Department of Forest Planning, Forest Administration Tyrol, Office of the Tyrolean government, Innsbruck, Austria  
3 Department of Geoinformatics – Z_GIS, University of Salzburg, Salzburg, Austria

*corresponding author   
email: simonalois@web.de  
postal address: Bürgerstraße 36, 6020 Innsbruck, Austria  



Keywords:  
species distribution modelling, environmental predictor variables, partitioning effects, soil information, Alpine environment, mountain forests 

Highlights:
- species distribution of silver fir and European beech is modelled with deep neural networks
- methods for addressing strong imbalance of absent and present are evaluated 
- regional and continental occurrence data and predictor variables are integrated
- predictive power of climatological, soil and topographical information were disintegrated

<br>
<br>

**Abstract**:<p align="justify">
Mountain forests in the European Alps cover inner Alpine distribution margins of several tree species and are therefore predestined to reveal soil-climatic-feedbacks on species distribution margins. Taking into account and combining different scales and extents are essential in species distribution models when it comes to the investigation of the environmental niche of a species. The study focuses on two levels of spatial extent, on the one hand the continental level of Europe and on the other hand at the regional level of the federal state of Tyrol in Austria. The potential occurrence of Abies alba and Fagus sylvatica is an important criterion for the delineation of elevational vegetation zones in forest site classification systems and was modelled with Deep Neural Networks. The potential predictor variables for modelling of the species distribution at the different spatial extents were grouped into climatological, soil and topographical information to allocate the predictive power of the groups. The combination of the different hierarchical levels of scale and extent was implemented by using the outputs of the continental model as predictor variable for the regional model. We observed a strong imbalance of absent and present recordings at the continental level and evaluated different methods to address this issue. The binary classification of the 30% test dataset showed a ROC-AUC of around 0.82 for the regional level and 0.94 for the continental level, with slighter higher values for Abies alba and Fagus sylvatica. For both species and level of extents, the climatological predictor group showed with 86.0 to 94.8 % the greatest importance for the predictive power of the species distribution models. Climate is followed by the predictor groups of soil and topographical information. The influence of the soil information on the occurrence probability changed along climatological gradients. In most cases the consideration of soil information led to a clear increase in occurrence probability at the climatic distribution edges. For the two investigated tree species we conclude that the inner Alpine distribution margins of Fagus sylvatica is stronger determined by edaphic conditions than for Abies alba. To further improve species distribution models in the Alpine area, for Fagus sylvatica and likely also other nutrient demanding deciduous tree species, a focus on soil information is proposed. In general, the models which combine continental and regional data are preferable. However, for a further development in this field, the applied methodology for the combination of the hierarchical levels as well as the capability of machine learning algorithms to handle hierarchical levels, need improvements.
</p>
<br>

**Conceptual Diagram:**

<kbd><img src="https://github.com/simonalois/sdm/blob/main/concept/conceptual_diagramm_hierachicalmodelling.jpg" title="Conceptual Diagram" /></kbd>
<br>
<br>
<a rel="license" href="http://creativecommons.org/licenses/by-nc-nd/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-nd/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-nd/4.0/">Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License</a>.
