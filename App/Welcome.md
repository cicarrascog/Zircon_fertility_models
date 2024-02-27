# Welcome

This app was created as part of the article "*Quantifying the criteria used to identify zircons from ore-bearing and barren systems in porphyry copper exploration"* by [Carlos Carrasco-Godoy](https://cicarrascog.github.io/), [Ian Campbell](https://earthsciences.anu.edu.au/professor-ian-campbell)  and [Yamila Cajal](https://discover.utas.edu.au/yamila.cajal), currently in press in the Economic Geology journal.

This Web App allows the classification of zircons using decision trees according to a set of selectable variables in the `Classification Tree` tab at the top.
This allows you to build simple decision trees according to the data that you have available.

The `Classification Tree` tab allows to train and test of a decision tree model based on the dataset of the publication above. `Random Forest` support will be added in a future update.

The left sidebar can be used to set up the tree depth of the model.
The right panel is divided into three sections:

1.  Metrics: Real-time cross-validation and test set metrics according to the variables selected in the settings sidebar.
2.  Visualization of the modelled decision tree (for low values of tree depth).
3.  Application of the model. Here you can upload your data and apply the model to it. Your data and results will be displayed once the model fit is complete.

## Important notes

1.  This model uses calculated La, Pr and Ce/Ce\* following the method of [Carrasco-Godoy and Campbell (2023)](https://link.springer.com/article/10.1007/s00410-023-02025-9). The [imputeREEapp](https://ccarr.shinyapps.io/ImputeREEapp) can be used to calculate these values.
2.  λ coefficients ([O'Neill, 2016](https://academic.oup.com/petrology/article/57/8/1463/2413419)) describe the REE pattern according to their features (slope, curvature, average REE content, etc.). λ~3~ is an excellent predictor of fertile zircons, on par with the Eu/Eu\*. λ coefficients can be calculated using the `pyrolite` package for `Python` or the [BLambdaR app](https://lambdar.rses.anu.edu.au/blambdar/) ([Anenburg and Williams, 2021](https://link.springer.com/article/10.1007/s11004-021-09959-5))
3.  Although the model can manage missing data, it is recommended to exclude any variable with a big proportion of missing values.

For the source code, please visit: <https://github.com/cicarrascog/Zircon_fertility_models>

Creator: [Carlos Carrasco-Godoy](https://cicarrascog.github.io) For bugs or questions contact: [carlos.carrasco\@anu.edu.au](mailto:carlos.carrasco@anu.edu.au)
