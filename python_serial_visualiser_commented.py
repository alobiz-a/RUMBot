# Import necessary libraries
import serial
import time
import matplotlib.pyplot as plt
import numpy as np

# Setup serial communication
ser = serial.Serial(
    port='COM3',             # Serial port to read data from
    baudrate=9600,           # Baud rate for communication
    parity=serial.PARITY_NONE,   # No parity checking
    stopbits=serial.STOPBITS_ONE, # Use one stop bit
    bytesize=serial.EIGHTBITS,    # Eight bits of data
    timeout=1                    # Timeout for read operation in seconds
)

# Function to plot distances on a polar plot
def plot_distance_simple(distances):
    # Ensure the distances array has exactly 8 elements
    if len(distances) != 8:
        raise ValueError("The distance array must contain 8 elements.")

    # Create angles for polar plot (0 to 360 degrees in steps of 45)
    angles = np.linspace(0, 2 * np.pi, 8, endpoint=False)

    # Close the plot by repeating the first value
    distances = np.append(distances, distances[0])
    angles = np.append(angles, angles[0])

    # Create polar plot
    fig, ax = plt.subplots(subplot_kw={'projection': 'polar'})
    ax.plot(angles, distances)
    ax.set_theta_zero_location('N')  # Zero angle at North
    ax.set_theta_direction(-1)       # Counterclockwise direction

    # Set labels and title
    angle_labels = [f'{deg}°' for deg in range(0, 360, 45)] + ['0°']
    ax.set_thetagrids(np.degrees(angles), labels=angle_labels)
    ax.set_title('Ultrasound Distance Measurements (mm)')
    ax.set_rlabel_position(-22.5)

    plt.show()  # Display the plot

# Function to create and show a 3D mesh plot
def make_mesh(radiis, max_height=1):
    num_rings, num_points = radiis.shape
    theta = np.linspace(0, 2 * np.pi, num_points, endpoint=False)
    height = np.linspace(0, max_height, num_rings*num_points).reshape(num_rings, num_points)

    # Closing the loop by duplicating first column
    theta = np.hstack((theta, [theta[0]]))
    radiis = np.hstack((radiis, radiis[:, 0][:, np.newaxis]))
    height = np.hstack((height, height[:, 0][:, np.newaxis]))

    # Convert to Cartesian coordinates for plotting
    x = radiis * np.cos(theta)
    y = radiis * np.sin(theta)

    # Create 3D plot
    fig, ax = plt.subplots(subplot_kw={'projection': '3d'})
    mesh = ax.plot_surface(x, y, height, cmap='viridis', edgecolor='k')

    # Connect the first and last points
    for i in range(num_rings):
        ax.plot([x[i, -1], x[i, 0]], [y[i, -1], y[i, 0]], [height[i, -1], height[i, 0]], color='k')

    ax.set_xlabel('X / mm')
    ax.set_ylabel('Y / mm')
    ax.set_zlabel('Z / mm')
    ax.set_title('3D rendering of surrounding')

    plt.show()  # Display the 3D plot

# Initialize an array to store data
data_array = []

# Continuous loop to read data from serial port
while True: 
    data = ser.readline()
    if data != b'':
        decoded_data = data.decode('utf-8').strip()  # Decode and strip data
        value = int(decoded_data)                    # Convert to integer
        data_array.append(value)                     # Add to array
        print(value)
        print('Array: ', data_array)

        # Process data every 8 values
        if len(data_array) % 8 == 0:
            plot_distance_simple(data_array[-8:])   # Plot last 8 values
            data_matrix = np.reshape(data_array, (-1, 8))  # Reshape for 3D plotting
            make_mesh(data_matrix)
