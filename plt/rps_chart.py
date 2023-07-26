import argparse
import pandas as pd
from matplotlib import pyplot as plt
from os.path import split


def create_plot(csv_file):
    data  = pd.read_csv(csv_file)
    data.head()
    df = pd.DataFrame(data)

    services = list(df.iloc[:, 0])
    values = list(df.iloc[:, 1])

    # Figure Size
    fig, ax = plt.subplots(figsize=(16, 9))

    # Horizontal Bar Plot
    ax.barh(services, values)

    # Remove axes splines
    for s in ['top', 'bottom', 'left', 'right']:
        ax.spines[s].set_visible(False)

    # Remove x, y Ticks
    ax.xaxis.set_ticks_position('none')
    ax.yaxis.set_ticks_position('none')

    # Add padding between axes and labels
    ax.xaxis.set_tick_params(pad=5)
    ax.yaxis.set_tick_params(pad=10)

    # Add x, y gridlines
    ax.grid(which='both', color='grey', linestyle='-.', linewidth=0.5, alpha=0.2)

    # Show top values
    ax.invert_yaxis()

    # Add annotation to bars
    for i in ax.patches:
        plt.text(i.get_width(), i.get_y() + 0.5, str(round((i.get_width()), 2)), fontsize=10, fontweight='bold', color='black')

    # Add Plot Title
    ax.set_title('Performance Of Different Services', loc='left')

    # Add Text watermark
    fig.text(0.9, 0.15, 'Speed Test', fontsize=12, color='grey', ha='right', va='bottom', alpha=0.7)

    # labels
    ax.set_xlabel('rps (requests/one sec)', fontweight='bold')

    directory_path, file_name = split(csv_file)
    # Save Plot as PNG with dynamic name based on input CSV
    file_name_without_extension = file_name.split('.')[0]
    plt.savefig(f'{directory_path}/{file_name_without_extension}.png')

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Create a horizontal bar plot from a CSV file.')
    parser.add_argument('csv_file', type=str, help='The CSV file to read data from')
    args = parser.parse_args()

    create_plot(args.csv_file)
