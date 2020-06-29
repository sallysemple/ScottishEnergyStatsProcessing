### Create List of Scripts, including filepath ###
Scripts <- list.files("Processing Scripts", full.names=TRUE,recursive = TRUE)

### Pass Each list item to Source() command ###

sapply(Scripts, source)
