import theano
import theano.tensor as T
import gym_rbf_cartpole
import numpy as np


class SGDRegressor:
    def __init__(self, D):

        print('hello theano!')
        w = np.random.randn(D) / np.sqrt(D)
        self.w = theano.shared(w)
        self.lr = 0.01

        X = T.matrix('X')
        Y = T.vector('Y')
        Y_hat = X.dot(self.w)
        delta = Y - Y_hat
        cost = T.mean(delta.dot(delta))
        grad = T.grad(cost, self.w)

        updates = [(self.w, self.w - self.lr * grad)]

        self.train_op = theano.function(
            inputs=[X, Y],
            updates=updates,
        )

        self.predict_op = theano.function(
            inputs=[X],
            outputs=Y_hat
        )


    def partial_fit(self, X, Y):
        self.train_op(X, Y)


    def predict(self, X):
        return self.predict_op(X)


if __name__ == '__main__':
    gym_rbf_cartpole.SGDRegressor = SGDRegressor
    gym_rbf_cartpole.main()
