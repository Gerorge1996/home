import numpy as np
import pandas as pd

class LogisticRegression:
    
    def __init__(self, learning_rate=0.01, max_iters=1000, tol=1e-4):
        """
        Инициализация модели логистической регрессии
        
        Parameters:
        learning_rate: скорость обучения
        max_iters: максимальное количество итераций
        tol: критерий остановки (изменение функции потерь)
        """
        self.learning_rate = learning_rate
        self.max_iters = max_iters
        self.tol = tol
        self.w = None
        self.w0 = None
        self.loss_history = []
    
    def _sigmoid(self, z):
        """Сигмоидная функция"""
        return 1 / (1 + np.exp(-np.clip(z, -250, 250)))  # clip для численной стабильности
    
    def _add_intercept(self, X):
        """Добавляет столбец единиц для intercept"""
        return np.concatenate((np.ones((X.shape[0], 1)), X), axis=1)
    
    def fit(self, features_train, target_train, verbose=False):
        """
        Обучение модели методом градиентного спуска
        
        Parameters:
        features_train: матрица признаков
        target_train: целевые переменные (0 или 1)
        verbose: вывод информации о процессе обучения
        """
        # Добавляем intercept
        X = self._add_intercept(features_train.values if hasattr(features_train, 'values') else features_train)
        y = target_train.values if hasattr(target_train, 'values') else target_train
        
        # Инициализация весов
        n_features = X.shape[1]
        self.w = np.zeros(n_features)
        
        # Градиентный спуск
        for i in range(self.max_iters):
            # Прямое распространение
            z = X @ self.w
            predictions = self._sigmoid(z)
            
            # Вычисление градиента
            error = predictions - y
            gradient = X.T @ error / len(y) # Производная от Log Loss!
            
            # Обновление весов
            self.w -= self.learning_rate * gradient
            
            # Вычисление функции потерь (log loss)
            loss = -np.mean(y * np.log(predictions + 1e-8) + (1 - y) * np.log(1 - predictions + 1e-8))
            self.loss_history.append(loss)
            
            # Проверка критерия остановки
            if i > 0 and abs(self.loss_history[-2] - loss) < self.tol:
                if verbose:
                    print(f"Сходимость достигнута на итерации {i}")
                break
            
            if verbose and i % 100 == 0:
                print(f"Итерация {i}, Loss: {loss:.4f}")
        
        # Сохраняем веса отдельно для intercept и коэффициентов
        self.w0 = self.w[0]
        self.w = self.w[1:]
        
        if verbose:
            print(f"Обучение завершено. Final loss: {loss:.4f}")
    
    def predict_proba(self, new_features):
        """
        Предсказание вероятностей принадлежности к классу 1
        
        Returns:
        Вероятности для класса 1
        """
        X = new_features.values if hasattr(new_features, 'values') else new_features
        z = X @ self.w + self.w0
        probabilities = self._sigmoid(z)
        return pd.Series(probabilities)
    
    def predict(self, new_features, threshold=0.5):
        """
        Предсказание классов
        
        Parameters:
        threshold: порог для классификации
        
        Returns:
        Предсказанные классы (0 или 1)
        """
        probabilities = self.predict_proba(new_features)
        predictions = (probabilities >= threshold).astype(int)
        return pd.Series(predictions)