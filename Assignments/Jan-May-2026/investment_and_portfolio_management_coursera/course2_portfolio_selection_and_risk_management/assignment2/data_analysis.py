import pandas as pd
import numpy as np
from dataclasses import dataclass
from typing import List

def weighted_average(returns, weights):
    return (returns * weights).sum() / weights.sum()

def weighted_std(cov_matrix, weights):
    return np.sqrt(np.dot(weights.T, np.dot(cov_matrix, weights)))

@dataclass
class VolatilityReturnsData:
    title: str
    mean: float
    std: float


def plot_volatility_returns(data: List[VolatilityReturnsData]):
    import matplotlib.pyplot as plt

    fig, ax = plt.subplots()
    fig.set_size_inches(20, 16)
    ax.set_title("Volatility vs Returns")
    ax.set_xlabel("Volatility (%)")
    ax.set_ylabel("Returns (%)")

    # make scatter plot to have unique color
    colors = plt.cm.viridis(np.linspace(0, 1, len(data)))
    for d, color in zip(data, colors):
        ax.scatter(d.std*100, d.mean*100, color=color, s=100)
        ax.annotate(f"{d.title} ({d.std*100:.4f}%, {d.mean*100:.4f}%)", (d.std*100, d.mean*100), xytext=(10, -5), textcoords='offset points')

    # show grid lines
    ax.grid(True)

    # show X, Y axis with 0.5 delta
    # collect min, max from data
    # min_x = min([d.std for d in data])
    # max_x = max([d.std for d in data])
    # min_y = min([d.mean for d in data])
    # max_y = max([d.mean for d in data])
    # ax.set_xlim(min_x*100 - 1, max_x*100 + 1)
    # ax.set_ylim(min_y*100 - 1, max_y*100 + 1)
    # ax.set_xticks(np.arange(0, min_x*100, max_x*100))
    # ax.set_yticks(np.arange(0, min_y*100, max_y*100))

    # make the plot show and wait
    plt.savefig("volatility_vs_returns.png", dpi=300, bbox_inches='tight', pad_inches=0.1)
    plt.show(block=True)

def main():
    excel_path = "Historical_monthly_return_data.xlsx"
    df = pd.read_excel(excel_path, index_col=0, skiprows=2)

    # Calculate monthly return for each stock
    return_df = df.pct_change().dropna()

    plot_data: List[VolatilityReturnsData] = []

    # mean, standard deviation, and variance
    mean = return_df.mean()
    std = return_df.std()
    var = return_df.var()

    # note down plot data fo
    for col in return_df.columns:
        plot_data.append(VolatilityReturnsData(col, mean[col], std[col]))

    print("Mean:\n", mean)
    print("\nStandard Deviation:\n", std)
    print("\nVariance:\n", var)

    # only consider MSFT, WBA, TSLA columns
    return_df = return_df[['MSFT', 'WBA', 'TSLA']]
    # mean, standard deviation, and variance
    mean = return_df.mean()
    std = return_df.std()
    var = return_df.var()

    # formulate variance-covariance matrix
    cov_matrix = return_df.cov()
    print("\nVariance-Covariance Matrix:\n", cov_matrix)

    # formulate correlation matrix
    corr_matrix = return_df.corr()
    print("\nCorrelation Matrix:\n", corr_matrix)

    # calculate weighted metrics
    weights = [np.array([1/3, 1/3, 1/3]), np.array([0.3, 0.2, 0.5]),
               np.array([0.5, 0.3, 0.2]), np.array([0.2, 0.5, 0.3])]

    for w in weights:
        print(f"\nWeights: {w}")
        weighted_mean = weighted_average(mean, w)
        weighted_std_dev = weighted_std(cov_matrix, w)

        print("\nWeighted Mean:\n", weighted_mean)
        print("\nWeighted Standard Deviation:\n", weighted_std_dev)

        # note down plot data for later use
        # make the weights precision as 2 decimal places
        w = np.array([round(i, 2) for i in w])
        plot_data.append(VolatilityReturnsData(f"Weighted {w}", weighted_mean, weighted_std_dev))

    # plot volatility and returns using maplotlib
    plot_volatility_returns(plot_data)

if __name__ == "__main__":
    main()