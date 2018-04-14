import pandas as pd
import numpy as np
from sklearn import tree
from sklearn.tree import DecisionTreeClassifier
from sklearn.tree import export_graphviz
from sklearn.model_selection import train_test_split

from matplotlib import pyplot as plt
import seaborn as sns

%matplotlib

# Importing dataset!
data = pd.read_csv("data.csv")

# Dataframes!
type(data)

# Nice Summary!
data.describe()

# Head!
data.head()

# Good Info!
data.info()


pos_tempo = data[data['target'] == 1]['tempo']
neg_tempo = data[data['target'] == 0]['tempo']

green_red = ["#97cc52","#d04738"]
pallete = sns.color_palette(green_red)
sns.set_palette(pallete)
sns.set_style("white")

# Plot 1 - tempo
# fig = plt.figure(figsize = (12, 8))
# plt.title("Song Tempo Like / Dislike Distribution")
# pos_tempo.hist(alpha = 0.7, bins = 30, label = 'positive')
# neg_tempo.hist(alpha = 0.7, bins = 30, label = 'negative')
# plt.legend(loc = "center right")


def getVariableTarget(data, variable, like):
    return data[data['target'] == like][variable]

# data.info()
# pos_acousticness = data[data['target'] == 1]['acousticness']
# neg_acousticness = data[data['target'] == 0]['acousticness']
# pos_danceability = data[data['target'] == 1]['danceability']
# neg_danceability = data[data['target'] == 0]['danceability']
# pos_speechiness = data[data['target'] == 1]['speechiness']
# neg_speechiness = data[data['target'] == 0]['speechiness']
# pos_valence = data[data['target'] == 1]['valence']
# neg_valence = data[data['target'] == 0]['valence']
# pos_loudness = data[data['target'] == 1]['loudness']
# neg_loudness = data[data['target'] == 0]['loudness']
# pos_duration_ms = data[data['target'] == 1]['duration_ms']
# neg_duration_ms = data[data['target'] == 0]['duration_ms']
# pos_energy = data[data['target'] == 1]['energy']
# neg_energy = data[data['target'] == 0]['energy']
# pos_instrumentalness = data[data['target'] == 1]['instrumentalness']
# neg_instrumentalness = data[data['target'] == 0]['instrumentalness']
# pos_key = data[data['target'] == 1]['key']
# neg_key = data[data['target'] == 0]['key']

target_data = {}

for column in list(data.columns.values):
    if column == 'Unnamed: 0':
        continue
    positiveKey = "pos_" + column
    negativeKey = "neg_" + column
    target_data[positiveKey] = data[data['target'] == 1][column]
    target_data[negativeKey] = data[data['target'] == 0][column]

target_data.keys()

fig2 = plt.figure(figsize = (15,15))

#Danceability
ax3 = fig2.add_subplot(331)
ax3.set_xlabel("Danceability")
ax3.set_ylabel("Count")
target_data['pos_danceability'].hist(alpha = 0.5, bins = 30)
target_data['neg_danceability'].hist(alpha = 0.5, bins = 30)

#Duration
ax4 = fig2.add_subplot(332)
ax4.set_xlabel("Duration")
ax4.set_ylabel("Count")
target_data['pos_duration_ms'].hist(alpha = 0.5, bins = 30)
target_data['neg_duration_ms'].hist(alpha = 0.5, bins = 30)

#Loudness
ax5 = fig2.add_subplot(333)
ax5.set_xlabel("Loudness")
ax5.set_ylabel("Count")
target_data['pos_loudness'].hist(alpha = 0.5, bins = 30)
target_data['neg_loudness'].hist(alpha = 0.5, bins = 30)

#Speechiness
ax6 = fig2.add_subplot(334)
ax6.set_xlabel("Speechiness")
ax6.set_ylabel("Count")
target_data['pos_speechiness'].hist(alpha = 0.5, bins = 30)
target_data['neg_speechiness'].hist(alpha = 0.5, bins = 30)

#Valence
ax7 = fig2.add_subplot(335)
ax7.set_xlabel("Valence")
ax7.set_ylabel("Count")
target_data['pos_valence'].hist(alpha = 0.5, bins = 30)
target_data['neg_valence'].hist(alpha = 0.5, bins = 30)

#Energy
ax8 = fig2.add_subplot(336)
ax8.set_xlabel("Energy")
ax8.set_ylabel("Count")
target_data['pos_energy'].hist(alpha = 0.5, bins = 30)
target_data['neg_energy'].hist(alpha = 0.5, bins = 30)

#Key
ax9 = fig2.add_subplot(337)
ax9.set_xlabel("Key")
ax9.set_ylabel("Count")
target_data['pos_key'].hist(alpha = 0.5, bins = 30)
target_data['neg_key'].hist(alpha = 0.5, bins = 30)

#Acousticness
ax10 = fig2.add_subplot(338)
ax10.set_xlabel("Acousticness")
ax10.set_ylabel("Count")
target_data['pos_acousticness'].hist(alpha = 0.5, bins = 30)
target_data['neg_acousticness'].hist(alpha = 0.5, bins = 30)

#Instrumentalness
ax10 = fig2.add_subplot(339)
ax10.set_xlabel("Instrumentalness")
ax10.set_ylabel("Count")
target_data['pos_instrumentalness'].hist(alpha = 0.5, bins = 30)
target_data['neg_instrumentalness'].hist(alpha = 0.5, bins = 30)

# Spliting test and train
train ,test = train_test_split(data, test_size = 0.15)
print('Train size: {}, Test Size: {}'.format(len(train), len(test)))
train.shape

# Lets Make a Decision Tree!
c = DecisionTreeClassifier(min_samples_split = 100)

# Making a list with the features (independent variables)
features = list(data.columns)
features.remove('Unnamed: 0')
features.remove('song_title')
features.remove('artist')
features.remove('target')
features

x_train = train[features]
y_train = train['target']

x_test = test[features]
y_test = test['target']

dt = c.fit(x_train, y_train)

import io
import pydotplus
import imageio

def show_tree(tree, features, path):
    f = io.StringIO()
    export_graphviz(tree, out_file = f, feature_names = features)
    pydotplus.graph_from_dot_data(f.getvalue()).write_png(path)
    img = imageio.imread(path)
    plt.rcParams["figure.figsize"] = (20, 20)
    plt.imshow(img)

show_tree(dt, features, "tree.png")

y_predict = c.predict(x_test)

from sklearn.metrics import accuracy_score

score = accuracy_score(y_test, y_predict) * 100

print("Accuracy using decision trees: ", round(score,2),"%")
