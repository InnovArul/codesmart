import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

class Portfolio:
    def __init__(self, names, expected_returns, std, correlation_matrix):
        self.names = names
        self.expected_returns = expected_returns
        self.std = std
        self.correlation_matrix = correlation_matrix

    def get_weighted_return(self, weights):
        return np.dot(weights, self.expected_returns)
    
    def get_weighted_std(self, weights):
        cov_matrix = np.outer(self.std, self.std) * self.correlation_matrix
        return np.sqrt(np.dot(weights.T, np.dot(cov_matrix, weights)))

    def get_mean_variance_frontier(self, num_points=100):
        results = []
        for x in range(num_points + 1):
            w = x / num_points
            weights = np.array([w, 1 - w])
            ret = self.get_weighted_return(weights)
            vol = self.get_weighted_std(weights)
            results.append((w, ret, vol))
    
        results = pd.DataFrame(results, columns=['weight', 'return', 'volatility'])
        return results

    def plot_frontiers(self, ax, color):
        frontier = self.get_mean_variance_frontier()
        # plot as scatter plot
        ax.scatter(frontier['volatility'], frontier['return'], s=10, color=color)
        # formulate legend based on correlation value
        legend = f"{self.names} Correlation: {self.correlation_matrix[0, 1]:.2f}"
        ax.plot(frontier['volatility'], frontier['return'], color=color, label=legend)

        # plot weights first and last with names
        ax.annotate(f"{self.names[0]} ({frontier['volatility'].iloc[0]:.3f}%, {frontier['return'].iloc[0]:.3f}%)", (frontier['volatility'].iloc[0] + 0.0003, frontier['return'].iloc[0]))
        ax.annotate(f"{self.names[1]} ({frontier['volatility'].iloc[-1]:.3f}%, {frontier['return'].iloc[-1]:.3f}%)", (frontier['volatility'].iloc[-1] + 0.0003, frontier['return'].iloc[-1]))

        # also plot minimum volatility point in same color
        min_vol = frontier.loc[frontier['volatility'].idxmin()]
        ax.annotate(f"Min. Vol. (w: {min_vol['weight']:.2f})\n( v: {min_vol['volatility']:.3f}%, ret: {min_vol['return']:.3f}%)", (min_vol['volatility'] + 0.0001, min_vol['return']), color=color)


def main():
    # define expected returns, std
    portfolio_uk_japan_part1 = Portfolio(names=['UK', 'Japan'],
                                    expected_returns=np.array([0.1589, 0.1497]),
                                    std=np.array([0.243, 0.2298]),
                                    correlation_matrix=np.array([[1, 0.3581], [0.3581, 1]]))

    portfolio_uk_japan_part2 = Portfolio(names=['UK', 'Japan'],
                                    expected_returns=np.array([0.1589, 0.1497]),
                                    std=np.array([0.243, 0.2298]),
                                    correlation_matrix=np.array([[1, 0.5], [0.5, 1]]))

    # calculate mean-variance frontier
    frontier_uk_japan_part1 = portfolio_uk_japan_part1.get_mean_variance_frontier()
    frontier_uk_japan_part2 = portfolio_uk_japan_part2.get_mean_variance_frontier()
    # save into excel
    frontier_uk_japan_part1.to_excel('frontier_uk_japan_part1.xlsx', index=False)
    frontier_uk_japan_part2.to_excel('frontier_uk_japan_part2.xlsx', index=False)

    # print minimum volatility portfolio
    print(frontier_uk_japan_part1.loc[frontier_uk_japan_part1['volatility'].idxmin()])
    print(frontier_uk_japan_part2.loc[frontier_uk_japan_part2['volatility'].idxmin()])

    # plot both frontiers in same graph
    plt.figure()
    plt.title('Mean-Variance Frontier')
    plt.xlabel('Volatility (%)')
    plt.ylabel('Expected Return (%)')
    plt.grid(True)
    fig = plt.gcf()
    fig.set_size_inches(12, 8)

    portfolio_uk_japan_part1.plot_frontiers(plt.gca(), color='blue')
    portfolio_uk_japan_part2.plot_frontiers(plt.gca(), color='orange')
    plt.legend(loc='upper left')

    # make the xticks, yticks to be percentage
    plt.gca().xaxis.set_major_formatter(plt.FuncFormatter(lambda x, _: '{:.02%}'.format(x)))
    plt.gca().yaxis.set_major_formatter(plt.FuncFormatter(lambda y, _: '{:.02%}'.format(y)))

    plt.savefig('frontier_uk_japan.png', dpi=300, bbox_inches='tight', pad_inches=0.1)
    plt.show(block=True)


if __name__ == "__main__":
    main()