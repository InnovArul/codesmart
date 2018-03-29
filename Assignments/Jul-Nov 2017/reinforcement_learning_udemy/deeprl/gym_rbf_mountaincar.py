# imports

import matplotlib.pyplot as plt
import os, sys, gym
from gym import wrappers
from datetime import datetime
from sklearn.pipeline import FeatureUnion
from sklearn.preprocessing import StandardScalar
from sklearn.kernel_approximation import RBFSampler
from sklearn.linear_model import SGDRegressor

class FeatureTransformer:
    def __init__(self, env):
        # sample the states and scale them
        observation_examples = np.array([env.observation_space.sample() for _ in range(10000)])
        scaler = StandardScalar()
        scaler.fit(observation_examples)

        # featurizer to union the RBF features
        featurizer = FeatureUnion([
        ("rbf1", RBFSampler(gamma=5.0, n_components=500)),
        ("rbf2", RBFSampler(gamma=2.0, n_components=500)),
        ("rbf3", RBFSampler(gamma=1.0, n_components=500)),
        ("rbf4", RBFSampler(gamma=0.5, n_components=500)),
        ])

        featurizer.fit(scaler.transform(observation_examples))

        self.scaler = scaler
        self.featurizer = featurizer

    def transform(self, observations):
        # scale the states
        scaled = self.scaler.transform(observations)
        # featurize
        return self.featurizer.transform(scaled)



class Model:
    def __init__(self, env, feature_transformer, learning_rate):
        self.env = env
        self.feature_transformer = feature_transformer
        self.models = []

        # create a model for each action
        for action in range(env.action_space.n):
            model = SGDRegressor(learning_rate=learning_rate)
            # SGDRegressor expects the partial_fit to be called atleast once before predicting
            model.partial_fit(feature_transformer.transform([env.reset()], [0]))
            self.models.append(model)

    def predict(self, observation):
        X = self.feature_transformer.transform([observation])
        return np.array([m.predict(X)[0] for m in self.models])

    def update(self, state, action, G):
        X = self.feature_transformer.transform([observation])
        self.models[action].partial_fit(X, [G])

    # sample action : epsilon greedy strategy
    def sample_action(self, s, eps):
        if np.random.random()< eps:
            return self.env.action_space.sample()
        else:
            p = self.predict(s)
            return np.argmax(p)
