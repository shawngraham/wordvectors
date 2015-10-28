## I always do this, just in case- MALLET uses java, who knows what else.
options(java.parameters = "-Xmx5120m")
### Ben Schmidt's WEM
library(devtools)
install_github("bmschmidt/wordVectors")
install.packages("magrittr")
library(magrittr)

## get the diaries into WEM
library(wordVectors)
model = train_word2vec("diariesWEM.csv",output="diaries.vectors",threads = 4,vectors = 1000,window=12)

## check to make sure there's stuff to play with:
model
rownames(model)

## now, iterate on some of the interesting words, and keep track. 
nearest_to(model,model[["Council"]])

# this gives the same, but rounds to a more sensible decimal place:
model %>% nearest_to(model[["Council"]]) %>% round(3)

# then, having found a list of interesting words, do something with it. for instance:
#a list of words loosely dealing with 'governance'

governance_words = model %>% nearest_to(model[[c("Parliament","Congress","Governor","Laws", "Power", "Council", "Church", "Colony", "Province")]],100) %>% names
sample(governance_words,50)

# get 100 close words to the governance vector
g = model[rownames(model) %in% governance_words [1:100],]

governance_distances = cosineDist(g,g) %>% as.dist
plot(as.dendrogram(hclust(governance_distances)),horiz=F,cex=1,main="Cluster dendrogram of the hundred words closest to a 'governance' vector\nin the diaries of John Adams")

#men, women, gender?
#humanity = nearest_to(model,model[[c("Man", "Inhabitants", "Mm.", "son", "Wife", "Dr.", "Child", "Grandfather", "Men.", "Nobles", "Humanity", "Girls", "Messrs.")]], 100)
#humanity_words = model %>% nearest_to(model[[c("Man", "Inhabitants", "Mm.", "son", "Wife", "Dr.", "Child", "Grandfather", "Men.", "Nobles", "Humanity", "Girls", "Messrs.")]],100) %>% names
#humanity_words = model %>% nearest_to(model[[c("Man", "Inhabitants", "son", "Wife", "Child", "Grandfather", "Men.", "Nobles", "Humanity", "Girls")]],100) %>% names

#humanity_words = model %>% nearest_to(model[[c("Man", "son", "Grandfather", "Men.", "Mans")]],100) %>% names
humanity_words = model %>% nearest_to(model[[c("Girls", "Wife", "home", "Family")]],100) %>% names

sample(humanity_words,50)
humans = model[rownames(model) %in% humanity_words [1:50]]
humanity_distances = cosineDist(humans,humans) %>% as.dist
plot(as.dendrogram(hclust(humanity_distances)),horiz=F,cex=1,main="Cluster dendrogram of the fifty words closest to a 'girls, wife, home, family' vector\nin the diaries of John Adams")


#install.packages("tsne")
# for two dimensional reduction of the vector space, use the following:
library(tsne)
plot(model)
plot(g)
