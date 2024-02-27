#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
# 


# Define server logic required to draw a histogram
function(input, output, session) {
  
  # Data #####
  datasets <- reactive({ ## Load Train and Test Data ######
    board_model <- board_folder(path = 'shiny_data')
    Zr_train <- board_model |>  pin_read(name = 'Zr_train_data') 
    Zr_test <- board_model |>  pin_read(name = 'Zr_test_data')
    
    list(Zr_train=Zr_train,
         Zr_test=Zr_test)
  })
  

  
  # Model definion ######
  
  
  
  recipe_vars <- reactive({ ## Recipe Definition #####
    
    recipe_vars <- recipe(datasets()[['Zr_train']])|> update_role(Class, new_role = 'outcome')|>  update_role(input$vars_to_model,new_role = 'predictor')|>  update_role(Deposit, new_role = 'Data')
    recipe_vars
    
  })
  
  model_spec <- reactive({ ## Model settings ########
    model <- decision_tree(tree_depth = input$tree_depth,
                           cost_complexity = 3.067676e-07, 
                           min_n = 38) |>
      set_engine('rpart') |>
      set_mode('classification')
    model
  })
  
  
  workflow <- reactive({ ## Workflow ######
    workflows::workflow() |>  add_model(model_spec()) |>  add_recipe(recipe_vars() )
  })
  
  trained_model <- reactive({ ### Trained model ###3
    trained_model <- workflow() |>  fit(data = datasets()[['Zr_train']])
})
  
  test_metrics <- reactive({ ## Resuls in the test set
    test_set <- trained_model() %>%  augment(datasets()[['Zr_test']])
    
    
    bind_rows(
      roc_auc(data = test_set, truth = Class, .pred_Fertile),
      sens(data = test_set, truth = Class, .pred_class),
      spec(data = test_set, truth = Class, .pred_class)%>% select(-.estimator) 
    )%>% select(-.estimator) %>%  rename(`test set` = .estimate)
    
  })
  
  
  # Crossvalidation ####
  CV_Metrics <- reactive({
    
    cls_metrics <- metric_set(roc_auc, sens, spec)
    control <- control_resamples(save_pred = T)
    
    rpart_level_5 <- fit_resamples(workflow(), metrics = cls_metrics, control = control, resamples = vfold_cv(datasets()[['Zr_train']], v = 10, repeats = 1, strata = Deposit))
    
    cv_metrics <- collect_metrics(rpart_level_5)  %>% select(-.estimator, -.config) %>%  rename(crossvalidation = mean)
    
    
    
  })
  All_metrics <- reactive({
    bind_cols( CV_Metrics(),test_metrics() %>%  select(-.metric)) %>% 
      relocate(`test set`, .before = crossvalidation) %>% 
      rename(Metric = .metric, `cv subsets` = n, `cv std error` = std_err,`cross-validation` = crossvalidation )
  })
  

  
  output$tree_plot <- renderPlot(
    {
      tree_fit  <- trained_model() %>% 
        extract_fit_parsnip()
      split.fun1 <- function(x, labs, digits, varlen, faclen)
      {
        labs <- str_replace( labs, '^P\\b', 'P (ppm)')
        labs <- str_replace( labs, '^Ce\\b', 'Ce (ppm)')
        labs <- str_replace( labs, '>=', '≥') 
        labs <- str_replace( labs, 'L0', 'λ0')
        labs <- str_replace( labs, 'L1', 'λ1')
        labs <- str_replace( labs, 'L2', 'λ2')
        labs <- str_replace( labs, 'L3', 'λ3')
        labs <- str_replace(labs, 'calculated_La', 'La (calculated, ppm)')
        labs <- str_replace(labs, 'calculated_Pr','Pr (calculated, ppm)')
        labs <- str_replace(labs, '^Nd\\b','Nd (ppm)')
        labs <- str_replace(labs, '^Sm\\b','Sm (ppm)')
        labs <- str_replace(labs, '^Eu\\b','Eu (ppm)')
        labs <- str_replace(labs, '^Gd\\b','Gd (ppm)')
        labs <- str_replace(labs, '^Tm\\b','Tm (ppm)')
        labs <- str_replace(labs, '^Dy\\b','Dy (ppm)')
        labs <- str_replace(labs, '^Ho\\b','Ho (ppm)')
        labs <- str_replace(labs, '^Y\\b','Y (ppm)')
        labs <- str_replace(labs, '^Er\\b','Er (ppm)')
        labs <- str_replace(labs, '^Tb\\b','Tb (ppm)')
        labs <- str_replace(labs, '^Yb\\b','Yb (ppm)')
        labs <- str_replace(labs, '^Lu\\b','Lu (ppm)')
        labs <- str_replace(labs, '^Th\\b','Th (ppm)')
        labs <- str_replace(labs, '^U\\b','U (ppm)')
        labs <- str_replace( labs, 'Eu_Eu', 'Eu/Eu*')
        labs <- str_replace( labs, 'Ce_Ce', 'Ce/Ce*')
        labs <- str_replace( labs, 'Gd_Yb', 'Gd/Yb')
        labs <- str_replace( labs, 'Th_U', 'Th/U')
        labs <- str_replace( labs, 'Sm_Yb', 'Sm/Yb')
        labs <- str_replace( labs, 'Dy_Yb', 'Dy/Yb')
        labs <- str_replace(labs, 'Ce_Nd', 'Ce/Nd')
        labs <- str_replace(labs, 'Gd_Yb','Gd/Tb')
        labs <- str_replace(labs, 'Sm_Yb', 'Sm/Yb')
        labs
      }
      rpart.plot::rpart.plot(tree_fit$fit,  type = 1, split.fun = split.fun1, extra = 4+100, box.palette = 'GnGy', split.font = 2, roundint = F, nn.font = 2, fam.main = 'Garamond', yesno = 2)
      # 
    }
  )
  
  
  # Renders   
  
 
  
  output$metrics <- renderTable({
    All_metrics()
    # CV_Metrained_modeltrics()
  })
  
  
  # template <- reactive({
  #   
  # })
  
  output$template <- downloadHandler(
    
    
     filename = function() {
      paste0('template', ".csv")
    },
    content = function(file) {
      template <- datasets()[['Zr_train']] %>%  slice(0)
      readr::write_csv(template, file)
    }
  )
  
  output$variables <- renderText({ 
    input$vars_to_model
  })
  
  output$CV_results <- renderTable({ #Cross Validation Table rendering #######
    # recipe_vars()
    CV_Metrics()
  })
  
  
  

    
    upload_data <- reactive({
      readr::read_csv(input$upload$datapath)
    })
    
    
     output$uploadcheck <- reactable::renderReactable({
      req(input$upload)
      upload_data() %>% reactable(., sortable = T, searchable = T, defaultPageSize = 3)
       
     })
  
     
       preds <- reactive({
   
      trained_model() |>  augment(new_data = upload_data())
      
    })  
    
    output$preds_table <- reactable::renderReactable({
      req(input$upload)
      preds() %>% relocate (.pred_class,.pred_Fertile, .pred_Barren)%>%  reactable(., sortable = T, searchable = T, defaultPageSize = 3)
    })
    
  output$download <- downloadHandler(
    
    filename = function() {
      paste0('predictions', ".csv")
    },
    content = function(file) {
      
      readr::write_csv(preds(), file)
    }
  )

}
