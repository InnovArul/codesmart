import gymnasium as gym
import torch
import numpy as np
import torch.nn as nn
import argparse
import matplotlib.pyplot as plt

def parse_args():
    parser = argparse.ArgumentParser(description="Sample Gym environment with PyTorch")
    parser.add_argument("--env_name", type=str, default="FrozenLake-v1", help="Name of the Gym environment")
    parser.add_argument("--map_name", type=str, default="8x8", help="Map name for FrozenLake environment")
    parser.add_argument("--is_slippery", action='store_true', help="Whether the FrozenLake environment is slippery")
    parser.add_argument("--render_mode", type=str, default=None, help="Render mode for the environment")
    parser.add_argument("--num_iterations", type=int, default=2500, help="Number of episodes to run")
    return parser.parse_args()


def create_env(env_name="FrozenLake-v1", map_name="8x8", is_slippery=False, render_mode=None):
    # Create a Gym environment
    env = gym.make(id=env_name, map_name=map_name, is_slippery=is_slippery, render_mode=render_mode)
    return env


class Model:
    def __init__(self, num_states, num_actions, epsilon=1, alpha=1.0, lambda_=0.9):
        self.q = np.zeros((num_states, num_actions))
        self.epsilon = epsilon
        self.alpha = alpha
        self.lambda_ = lambda_

    def reset(self, reset_q=True):
        # Reset the Q-values and other parameters
        if reset_q:
            self.q.fill(0)

    def step(self):
        # reduce epsilon over time
        self.epsilon = max(0.01, self.epsilon * 0.99)

        # reduce learning rate over time
        self.alpha = max(0.01, self.alpha * 0.99)

    def update(self, state, action, reward, next_state, done):
        # Update the Q-value for the given state-action pair
        best_next_action = self.get_best_action(next_state)

        # Calculate the TD target and update the Q-value
        td_target = reward + (self.lambda_ * self.q[next_state][best_next_action] * (not done))
        td_error = td_target - self.q[state][action]
        self.q[state][action] += self.alpha * td_error

    def get_best_action(self, state):
        # Choose an action based on the current state
        best_value = self.q[state].max()
        best_actions = np.where(self.q[state] == best_value)[0]
        return np.random.choice(best_actions)

    def get_action(self, state):
        # Epsilon-greedy action selection
        if np.random.rand() < self.epsilon:
            return np.random.randint(len(self.q[state]))
        else:
            return self.get_best_action(state)

def main():
    args = parse_args()
    print(args)

    # Create a Gym environment
    env = create_env(
        env_name=args.env_name,
        map_name=args.map_name,
        is_slippery=args.is_slippery,
        render_mode=args.render_mode
    )
    print(f"Created environment: {env}")

    # Reset the environment to get the initial state
    state = env.reset()
    print(state)

    # Initialize the model
    num_states = env.observation_space.n
    num_actions = env.action_space.n
    model = Model(num_states=num_states, num_actions=num_actions)
    print(f"Model initialized with {num_states} states and {num_actions} actions.")
    model.reset()

    # plot the reward function
    rewards = []

    # Run the environment for a number of episodes
    for iteration in range(args.num_iterations):
        print(f"Iteration {iteration + 1}/{args.num_iterations}")

        # each iteration runs for 100 episodes
        total_reward = 0
        for episode in range(100):
            # Reset the environment for a new episode
            state, info = env.reset()
            terminal = False
            truncated = False
            steps = 0

            # Run the episode
            while not terminal and not truncated:
                # Sample a random action
                action = model.get_action(state)

                # Take a step in the environment
                next_state, reward, terminal, truncated, info = env.step(action)
                # print(f"Action taken: {action}, Next state: {next_state}, Reward: {reward}, Terminal: {terminal}, Truncated: {truncated}")

                # Update the model with the new state and reward
                model.update(state, action, reward, next_state, terminal)

                # Update the state
                state = next_state

                # Print the state and reward
                # print(f"State: {state}, Reward: {reward}")
                total_reward += reward
                steps += 1

            # print total steps taken in the episode
            # print(f"Episode finished after {steps} steps.")
        # Append the total reward for this episode
        rewards.append(total_reward)

        # total reward for the episode
        print(f"Iteration {iteration + 1}/{args.num_iterations}: finished with total reward: {total_reward}")

        model.step()

    plt.plot(rewards)
    plt.savefig("gym_torch_sample_rewards.png")
    # Close the environment
    env.close()


if __name__ == "__main__":
    main()