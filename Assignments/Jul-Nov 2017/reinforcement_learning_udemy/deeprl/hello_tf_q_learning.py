import numpy as np
import tensorflow as tf
import gym_rbf_cartpole

class SGDRegressor:
    def __init__(self, D):
        print('hello tf')
        lr = 0.01
        
        self.w = tf.Variable(tf.random_normal(shape=(D,1), name='w'))
        self.X = tf.placeholder(tf.float32, shape=(None, D), name='X')
        self.Y = tf.placeholder(tf.float32, shape=(None,), name='Y')
        
        # make prediction and cost
        Y_hat = tf.reshape(tf.matmul(self.X, self.w), [-1])
        delta = self.Y - Y_hat
        cost = tf.reduce_sum(delta * delta)
        
        # ops we want to call later
        self.train_op = tf.train.GradientDescentOptimizer(lr).minimize(cost)
        self.predict_op = Y_hat

        # start the session and initialize params
        init = tf.global_variables_initializer()
        self.session = tf.InteractiveSession()
        self.session.run(init)


    def partial_fit(self, X, Y):
        self.session.run(self.train_op, feed_dict={self.X: X, self.Y: Y})

    def predict(self, X):
        return self.session.run(self.predict_op, feed_dict={self.X: X})


if __name__ == '__main__':
    gym_rbf_cartpole.SGDRegressor = SGDRegressor
    gym_rbf_cartpole.main()
