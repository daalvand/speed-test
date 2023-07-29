import csv
from matplotlib import pyplot as plt
import sys
import io


def create_plot(csv_file):
    services, values = read_csv_file(csv_file)

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
        plt.text(i.get_width(), i.get_y() + 0.5, str(round((i.get_width()), 2)), fontsize=10, fontweight='bold',
                 color='black')

    # Add Plot Title
    ax.set_title('Performance Of Different Services', loc='left')

    # Add Text watermark
    fig.text(0.9, 0.15, 'Speed Test', fontsize=12, color='grey', ha='right', va='bottom', alpha=0.7)

    # labels
    ax.set_xlabel('rps (requests/one sec)', fontweight='bold')

    # Save the plot to an in-memory buffer
    buffer = io.BytesIO()
    plt.savefig(buffer, format='png')
    buffer.seek(0)

    # Retrieve the image data as bytes and return it
    image_content = buffer.getvalue()

    buffer.close()
    return image_content  # Decode the bytes to a string before printing


def read_csv_file(csv_file):
    csv_file = io.StringIO(csv_file)
    # Read the CSV data
    csv_reader = csv.DictReader(csv_file)
    # Extract the data from the CSV
    services = []
    values = []
    for row in csv_reader:
        services.append(row['service'])
        values.append(float(row['rps']))
    return services, values


class InvalidCSVException(Exception):
    pass


if __name__ == "__main__":
    if len(sys.argv) > 1:
        csv_file_input = sys.argv[1]
        sys.stdout.buffer.write(create_plot(csv_file_input))
    else:
        print("No CSV data provided.")
        exit(1)
