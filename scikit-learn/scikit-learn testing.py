
# coding: utf-8

# In[1]:

import numpy
from sklearn import datasets, linear_model, cross_validation, feature_selection, grid_search, metrics


# In[49]:

sample = 100000
data = datasets.make_multilabel_classification(n_samples=sample, n_features=200, n_classes=1, n_labels=2, length=50, allow_unlabeled=True, return_indicator = True,random_state=None)

print data[1]
print data[0]


# In[50]:

##Split the data and create the logistic regression object
X_train, X_test, y_train, y_test = cross_validation.train_test_split(data[0], data[1], test_size=.99, random_state=0)

logreg = linear_model.LogisticRegression()

y_train.shape = (y_train.shape[0],)
y_test.shape = (y_test.shape[0],)


# In[107]:

##Loop through necessary parameters

##parameters
fs_alpha = [0.1,0.2,0.3,0.4,0.5,0.7]
logreg_C = [1.0,0.8,0.6,0.4,0.2]


i=1
k=0
mse = [[]]
for c in logreg_C:
    for a in fs_alpha:
    
        print "Run: {0}, Alpha = {1}, C = {2}".format(i,a,c)
        ##Feature Selection
        print 'Size of original training variables : {0}'.format(X_train.shape)
        print 'Size of original testing variables : {0}'.format(X_test.shape)
        ##Set the feature selector object:
        fs = feature_selection.SelectFwe(feature_selection.chi2, alpha = a)
        ##Set C value for logreg
        logreg.set_params(C=c)
        ##Create new training set of features
        X_train2 = fs.fit_transform(X_train,y_train)
        
        print 'Size of new training variables : {0}'.format(X_train2.shape)

        ##Take unneeded features out the test set
        X_test2 = X_test[:,fs.get_support()]
        print 'no. variables: {0}'.format(len(fs.get_support()[fs.get_support()]))
        print 'Size of new testing variables : {0}'.format(X_test2.shape)

        ##Fit the logisitic regression model
        logreg.fit(X_train2,y_train)

        ##predict the model on the test data
        y_predict = logreg.predict(X_test2)

        ##print scores of model
        print "Accuracy: {0}".format(metrics.accuracy_score(y_test,y_predict))
        print "MSE: {0}".format(metrics.mean_squared_error(y_test,y_predict))
        mse[k].append(metrics.mean_squared_error(y_test,y_predict))
        #print "confusion matrix: \n{0}".format(metrics.confusion_matrix(y_test,y_predict))

        print "Report: \n{0}".format(metrics.classification_report(y_test,y_predict))
        print "\n"
        i += 1
    if k != (len(logreg_C)-1):
        mse.append([])
        k += 1


# In[96]:

print mse
mse_flat = [item for subset in mse for item in subset]
print min(mse_flat)
ind = mse_flat.index(min(mse_flat))
print ind
t1 = (ind % len(logreg_C)) - 1
t2 = ind - (t1)*len(logreg_C)
print t1
print t2
print "Best parameters - alpha: "+str(fs_alpha[t2])+" and C: "+str(logreg_C[t1])+"with mse: min(mse_flat)"




# In[90]:

cv_scores = cross_validation.cross_val_score(logreg, X_test2,y_test,cv=10)

print numpy.mean(cv_scores)


# In[ ]:

##Split the data and create the logistic regression object
X_train, X_test, y_train, y_test = cross_validation.train_test_split(data[0], data[1], test_size=.99, random_state=0)

logreg2 = linear_model.LogisticRegression()

y_train.shape = (y_train.shape[0],)
y_test.shape = (y_test.shape[0],)


