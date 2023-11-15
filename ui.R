library(shiny)
library(bslib)
library(pins)
library(dplyr)
library(stringr)
library(rpart)
library(reactable)
library(tidymodels)




Variable_Choices <- tribble(
  ~Option,
  ~Variable,
  "P (ppm)",
  "P",
  "La (calculated, ppm)",
  "calculated_La",
  "Ce (ppm)",
  "Ce",
  "Pr (calculated, ppm)",
  "calculated_Pr",
  "Nd (ppm)",
  "Nd",
  "Sm (ppm)",
  "Sm",
  "Eu (ppm)",
  "Eu",
  "Gd (ppm)",
  "Gd",
  "Tm (ppm)",
  "Tm",
  "Dy (ppm)",
  "Dy",
  "Ho (ppm)",
  "Ho",
  "Y (ppm)",
  "Y",
  "Er (ppm)",
  "Er",
  "Tb (ppm)",
  "Tb",
  "Yb (ppm)",
  "Yb",
  "Lu (ppm)",
  "Lu",
  "Th (ppm)",
  "Th",
  "U (ppm)",
  "U",
  "Eu/Eu*",
  "Eu_Eu",
  "Ce/Ce* (see note)",
  "Ce_Ce",
  "Th/U",
  "Th_U",
  "Ce/Nd",
  "Ce_Nd",
  "Dy/Yb",
  "Dy_Yb",
  "Gd/Yb",
  "Gd_Yb",
  "Sm/Yb",
  "Sm_Yb",
  "λ0",
  "L0",
  "λ1",
  "L1",
  "λ2",
  "L2",
  "λ3",
  "L3"
)





page_navbar(
  title = "Zircon Fertility models",
  selected = "Welcome",
  collapsible = TRUE,
  theme = bslib::bs_theme(),
  nav_panel(title = "Welcome", includeMarkdown("Welcome.md")),
  nav_panel(
    title = "Classification Tree",
    page_sidebar(
      sidebar = sidebar(
        title = "Settings",
        shiny::numericInput(
          label = "Tree Depth",
          min = 1,
          max = 15,
          inputId = "tree_depth",
          value = 10
        ),
        shiny::checkboxGroupInput(
          selected = c(
            "Eu_Eu", "P", "Ce_Nd",
            "Dy_Yb"
          ),
          inputId = "vars_to_model",
          choiceNames = Variable_Choices$Option,
          choiceValues = Variable_Choices$Variable,
          label = "Input variables to model"
        )
      ),
      tabsetPanel(
        nav_panel(
          title = "Metrics",
          markdown(''),
          markdown("**Metrics should be similar in both, test and crossvalidation**"),       
          markdown("Area under the ROC curve (ROC AUC): probability that the model will rank higher a random fertile zircon than a randomly selected barren zircon"),           markdown("**Sensitivity:** Proportion of fertile zircons correctly classified among the fertile zircon"),       
          markdown("**Specificity**: Proportion of barren Zircons, correctly classified among the barren zircons"),
          
          card(  card_header(
            "Metrics table"
          ),
          card_body(
          shiny::tableOutput("metrics")
          )),
        ),
        nav_panel(
          title = "Tree Plot",
          markdown("### High tree depth values are not properly visualized"),
          shiny::plotOutput("tree_plot")
          
        ), 
        nav_panel(
          title = "Predict",
          card(markdown('This is a template to prepare your data. Interpret `_` as `/`, `L` as `λ`, and `Eu_Eu` and `Ce_Ce` as the `Eu/Eu*` and `Ce/Ce*`, respectively.'),
               markdown('The Ce/Ce*, La and Pr in this model is the one calculated by the method of [Carrasco-Godoy and Campbell (2023)](https://link.springer.com/article/10.1007/s00410-023-02025-9). The [imputeREEapp](https://ccarr.shinyapps.io/ImputeREEapp) can be used to calculate these values.'),
               markdown("λ coefficients ([O'Neill, 2016](https://academic.oup.com/petrology/article/57/8/1463/2413419)) can be calculated with the pyrolite package of `python` or the [BLambdaR app](https://lambdar.rses.anu.edu.au/blambdar/) ([Anenburg and Williams, 2021](https://link.springer.com/article/10.1007/s11004-021-09959-5))."),
               downloadButton("template", "Download data template")),
          
          card(markdown('The model is fitted only with the checkbox selected in the settings sidebar on the left side of this page.'),
               
               fileInput( inputId= "upload",label = 'Upload' ,placeholder  = 'upload your data as .csv', accept = '.csv', multiple = F), 
               reactable::reactableOutput('uploadcheck')
               ), 
          
          card(
            markdown('The probabilities produced by this model are not calibrated, therefore they should not be interpreted as true probabilities. Instead, they can be used to rank zircons.'),
               markdown('**Bigger files will take longer to process**'), 
            downloadButton("download", "Download predictions"),
            reactable::reactableOutput('preds_table') ), 
          
        )
      )
    )
  ),
  nav_panel(title = "Licence",
            includeMarkdown('LICENSE.md')),
)
