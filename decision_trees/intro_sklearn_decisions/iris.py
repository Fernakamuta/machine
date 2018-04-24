from sklearn import tree
from sklearn.datasets import load_iris
import numpy as np

# Carregando Dataset iris
iris = load_iris()

# Examinando o Dataset
dir(iris)
iris.feature_names
iris.target_names

# Separando exemplos para treino e teste
test_idx = [0, 50, 100]

# training data
train_target = np.delete(iris.target, test_idx)
train_data = np.delete(iris.data, test_idx, axis=0)

# test data
test_target = iris.target[test_idx]
test_data = iris.data[test_idx]

# Treinando a arvore
clf = tree.DecisionTreeClassifier()
clf.fit(train_data, train_target)

# Aplicando o predict nas variaveis de  teste
clf.predict(test_data)

# Uhuuu, identico ao que esperavamos
test_target



import graphviz
dot_data = tree.export_graphviz(clf, out_file=None,
                         feature_names=iris.feature_names,
                         class_names=iris.target_names,
                         filled=True, rounded=True,
                         special_characters=True)
graph = graphviz.Source(dot_data)
graph.render("iris")
graph
