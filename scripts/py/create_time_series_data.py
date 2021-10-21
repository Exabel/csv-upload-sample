import numpy as np
import pandas as pd


def get_brownian_time_series(
    from_date="2020-01-01", to_date="2021-10-01", start_price=100
):
    def geometric_brownian_motion(T=1, N=100, mu=0.1, sigma=0.01, S0=20):
        # Borrowed from https://stackoverflow.com/questions/16734621/random-walk-pandas
        dt = float(T) / N
        t = np.linspace(0, T, N)
        W = np.random.standard_normal(size=N)
        W = np.cumsum(W) * np.sqrt(dt)  ### standard brownian motion ###
        X = (mu - 0.5 * sigma ** 2) * t + sigma * W
        S = S0 * np.exp(X)  ### geometric brownian motion ###
        return S

    dates = pd.date_range(from_date, to_date)
    T = (dates.max() - dates.min()).days / 365
    N = dates.size
    return pd.Series(
        geometric_brownian_motion(T, N, sigma=0.1, S0=start_price), index=dates
    )


def main():
    brands: pd.DataFrame = pd.read_csv("./resources/data/entities/brands.csv", sep=";")

    time_series = []
    for brand in brands.brand.values:
        next_series = get_brownian_time_series(
            start_price=np.random.randint(50, 2000 + 1)
        )
        signal_name = "sample_revenue"
        next_series.name = signal_name
        next_series.index.name = "date"
        next_df = pd.DataFrame(next_series).reset_index()
        next_df["brand"] = brand
        next_df = next_df[["brand", "date", signal_name]]
        time_series.append(next_df)

    pd.concat(time_series).to_csv(
        "./resources/data/time_series/brand_time_series.csv",
        sep=";",
        quoting=2,
        index=False,
    )


if __name__ == "__main__":
    np.random.seed(1)
    main()
