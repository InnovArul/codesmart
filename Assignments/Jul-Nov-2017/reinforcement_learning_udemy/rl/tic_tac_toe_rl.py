import os, sys
import numpy as np

LENGTH = 3

class Environment:
    # constructor
    def __init__(self):
        self.board = np.zeros((LENGTH, LENGTH))
        self.winner = None
        self.x = -1
        self.o = 1
        self.ended = False
    
    # is game over already?
    def is_game_over(self, force_recalculate = False, draw_board=False):
        # if the recalculation is not forced, then return cached decision about ending        
        if (not force_recalculate) and self.ended:
            return self.ended
        
        # in other cases, recalculate the decision based on current board state
        # check row wise
        for player in (self.o, self.x):
            if np.any(np.sum(self.board, 1) == LENGTH * player):
                self.winner = player
                self.ended = True
                return True 
        
        # check column wise
        for player in (self.o, self.x):
            if np.any(np.sum(self.board, 0) == LENGTH * player):
                self.winner = player
                self.ended = True
                return True     
                
        # check diagonal wise
        for player in (self.o, self.x):
            if np.sum(np.trace(self.board)) == LENGTH * player:
                self.winner = player
                self.ended = True
                return True 
                
        # check diagonal wise
        for player in (self.o, self.x):
            if np.sum(np.trace(np.fliplr(self.board))) == LENGTH * player:
                self.winner = player
                self.ended = True
                return True 
                
        # check draw
        if np.all(self.board != 0):
            self.winner = None
            self.ended = True
            return True      

        self.winner = None
        self.ended = False
        return False
                    
    # get the value of a board symbol
    def get_value(self, board_symbol):
        if(board_symbol == self.o):
            return 1
        elif(board_symbol == self.x):
            return 2
        else:
            return 0
        
    def get_state(self):
        # get the state identity number
        state_identity_index = 0
        
        for i in range(LENGTH):
            for j in range(LENGTH):
                value = self.get_value(self.board[i, j])
                digit_position = (i * LENGTH) + j
                state_identity_index += ((LENGTH ** digit_position) * value)

        return state_identity_index

    def is_empty(self, i, j):
        return self.board[i, j] == 0

    # get the reward for a particular player
    def get_reward(self, sym):
        if self.ended is False:
            return 0
            
        if self.winner == sym:
            return 1
        
        return 0
    
    def get_symbol(self, boardsymbol):
        if boardsymbol == self.x:
            return 'x'
        elif boardsymbol == self.o:
            return 'o'
        else:
            return '-'
    
    def draw_board(self):
        for i in range(LENGTH):
            print('\n---------')
            for j in range(LENGTH):
                print self.get_symbol(self.board[i, j]) + ' ',
        print('\n---------')
        #input()

#-----------------------------------------------------------------------

def get_init_weight(is_ended, winner, symbol):
    if not is_ended:
        return 0.5
    
    if winner == symbol:
        return 1
    else:
        return 0
        
#-----------------------------------------------------------------------

class Agent:
    def __init__(self, eps, symbol, state_winner_triples, verbose = False, alpha = 0.5):
        self.eps = eps
        self.symbol = symbol
        self.V = self.create_value_array(state_winner_triples, symbol)
        self.state_history = []
        self.verbose = verbose
        self.alpha = alpha

    def create_value_array(self, state_winner_triples, symbol):
        V = np.zeros(len(state_winner_triples))
        #print(state_winner_triples)
        for i in range(len(state_winner_triples)):
            state, is_ended, winner = state_winner_triples[i]
            V[state] = get_init_weight(is_ended, winner, symbol)
        
        return V

    def set_verbose(self, verbose):
        self.verbose = verbose
        
    def set_eps(self, eps):
        self.eps = eps

    def clear_history(self):
        self.state_history = []
        
    def update_state(self, state):
        self.state_history.append(state)
    
    def print_values(self, all_free_locations, values):
        if not self.verbose:
            return
        
        board = np.zeros((LENGTH, LENGTH))
        for i, free_location in enumerate(all_free_locations):
            board[free_location] = values[i]
        
        for i in range(LENGTH):
            print('\n---------')
            for j in range(LENGTH):
                print str(board[i, j]) + ' ',
        print('\n---------')
        
    def take_action(self, env):
        if(self.verbose):
            print('inside action function') 
                   
        # get the random number
        p = np.random.rand()

        #print(env.board)
        all_free_locations = zip(*np.where(env.board == 0))
        
        if(p < self.eps):
            # to explore, select a random location
            # collect all the empty locations   
            if(self.verbose):
                print('exploring with a random action')

            next_move = all_free_locations[np.random.choice(len(all_free_locations))]            
        else:
            if(self.verbose):
                print('exploiting with maximum valued action')
                            
            values = []
            #print(all_free_locations)
            #input()
            
            # to exploit, select the location with highest value
            for free_location in all_free_locations:
                env.board[free_location] = self.symbol
                state = env.get_state()
                env.board[free_location] = 0 # reset the board to previous state
                values.append(self.V[state])
            
            self.print_values(all_free_locations, values)
            next_move = all_free_locations[np.argmax(values)]
        
        env.board[next_move] = self.symbol
            
    def update(self, env):
        reward = env.get_reward(self.symbol)
        target = reward
        
        for state in reversed(self.state_history):
            self.V[state] += self.alpha * (target - self.V[state])
            target = self.V[state]
            
        self.clear_history()

#-----------------------------------------------------------------------

class Human:
    def __init__(self, symbol):
        self.symbol = symbol

    def clear_history(self):
        pass
        
    def update_state(self, state):
        pass
        
    def take_action(self, env):
        while True:
            # break if we make a legal move
            move = raw_input("Enter coordinates i,j for your next move (i,j=0..2): ")
            i, j = move.split(',')
            i = int(i)
            j = int(j)
            if env.is_empty(i, j):
                env.board[i,j] = self.symbol
                break
            
    def update(self, env):
        pass

#-----------------------------------------------------------------------
def get_state_winner_ended_list(env, i=0, j=0):
    result_list = []
    
    # for each possible symbol
    for symbol in (0, env.o, env.x):
        env.board[i, j] = symbol
        
        if(j == 2):
            if(i == 2):
                # if the board final position is reached, get the state and check who is the winner        
                state = env.get_state()
                is_ended = env.is_game_over(force_recalculate = True)
                winner = env.winner
                result_list.append((state, is_ended, winner))
            else:
                # go to next row
                result_list += get_state_winner_ended_list(env, i+1, 0)
        else:
            # go to next column
            result_list += get_state_winner_ended_list(env, i, j+1)
            
    return result_list
    
#-----------------------------------------------------------------------

def play_game(agent1, agent2, environment, draw_board=False):
    current_player = agent2
    game_status = environment.is_game_over(draw_board=draw_board)
    
    while not game_status:
        #print(game_status)
        #input()
        if(current_player == agent2):
            current_player = agent1
        else:
            current_player = agent2
            
        current_player.take_action(environment)
        state = environment.get_state()
        
        if draw_board:
            environment.draw_board()
        
        agent1.update_state(state)
        agent2.update_state(state)
        
        game_status = environment.is_game_over()
        
    agent1.update(environment)
    agent2.update(environment)

if(__name__ == '__main__'):
    env = Environment()
    state_winner_triples = get_state_winner_ended_list(env)
    eps = 0.2
    
    agent1 = Agent(eps, env.o, state_winner_triples, False)
    agent2 = Agent(eps, env.x, state_winner_triples, False)
    
    print('starting training between the agents')
    for i in range(50000):
        if(i % 200 == 0):
            print(i)
        play_game(agent1, agent2, Environment(), False)
    
    print('start playing with the agent')
    agent1.set_verbose(True)
    agent1.set_eps(0)
    human = Human(env.x)
    while True:
        play_game(agent1, human, Environment(), True)
        answer = raw_input("Play again? [Y/n]: ")
        if answer and answer.lower()[0] == 'n':
          break

