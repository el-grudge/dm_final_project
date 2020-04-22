stepWiseReduce
#stepWiseMod <-stepAI(logitMod, direction = "both", trace = FALSE)
data <- dplyr::select(data, target, feat4, feat6, feat7, feat8, feat12, feat13, feat14, feat15, 
                      feat20, feat31, feat39, feat40, feat42, feat56, feat63, feat66,
                      feat69, feat71, feat75)

rfReduce
data <- dplyr::select(data, target, feat1, feat2, feat3, feat4, feat5, feat6, feat7, feat8, 
                      feat9, feat10, feat11, feat12, feat13, feat14, feat15, feat16,
                      feat17, feat18, feat19, feat20, feat21, feat22, feat23, feat24, feat25,
                      feat64, feat65, feat66, feat67, feat72, feat73, feat74, feat75, feat76,
                      feat77, feat78)

removeCoLinear
