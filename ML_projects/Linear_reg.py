#Линейная регрессия в простоте ее представления
class LinearRegression:
    
    def fit(self,features_train,target_train):
        
        X = np.concatenate((np.ones((features_train.shape[0], 1)), features_train), axis=1)
        y = target_train
        
        w = (np.linalg.inv(X.T@X))@X.T@y
        
        print(w)
        
        self.w = w[1:]
        self.w0 = w[0]
    
    def predict(self,new_features):
               
        pred = new_features.values@self.w + self.w0

        return pd.Series(list(pred))
    
#Линейная регрессия по бачам градиентным спуском
class SGDLinearRegression:
    def __init__(self,step_size,epochs,batch_size):
        self.step_size = step_size
        self.epochs = epochs
        self.batch_size = batch_size
        
    def fit(self,train_features,train_target):
        X = np.concatenate((np.ones((train_features.shape[0], 1)), train_features), axis=1)
        y = train_target
        
        if train_features.shape[0]%self.batch_size !=0:
            batches = int(np.ceil(train_features.shape[1]/self.batch_size))
        else:
            batches = int(train_features.shape[0]/self.batch_size)
        
        
        print(f'batches = {batches}')
        w = np.zeros(features_train.shape[1]+1)
        
        for epoch in range(self.epochs):
            for batch in range(batches):
                begin = batch*self.batch_size
                end = (batch+1)*self.batch_size
                
                X_batch = X[begin:end,:]
                y_batch = y[begin:end]
                
                
                gradient = (2/len(X_batch))*X_batch.T@(X_batch@w - y_batch)
                
            
                w = w-self.step_size*gradient
            
        
        self.w=w[1:]
        self.w0=w[0]
        
    def predict(self,test_features):
        
        X = test_features.values
        
        pred = X@self.w + self.w0
        
        return pd.Series(list(pred))