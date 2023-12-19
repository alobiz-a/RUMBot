import serial
import time
import matplotlib.pyplot as plt
import numpy as np

ser = serial.Serial(

    port='COM3',

    baudrate=9600,

    parity=serial.PARITY_NONE,

    stopbits=serial.STOPBITS_ONE,

    bytesize=serial.EIGHTBITS,

    timeout=1

)

def plot_distance_simple(distances):
    # Check if the length of the distances array is 8
    if len(distances) != 8:
        raise ValueError("The distance array must contain 8 elements.")

    # Create an array for the angles (0, 45, 90, ..., 315 degrees)
    angles = np.linspace(0, 2 * np.pi, 8, endpoint=False)

    # Repeat the first value to close the circle in the plot
    distances = np.append(distances, distances[0])
    angles = np.append(angles, angles[0])

    # Create a polar plot
    fig, ax = plt.subplots(subplot_kw={'projection': 'polar'})
    ax.plot(angles, distances)

    # Set the direction of the zero angle
    ax.set_theta_zero_location('N')

    # Set the angle offset (counterclockwise)
    ax.set_theta_direction(-1)

    # Add labels, title, etc.
    angle_labels = [f'{deg}°' for deg in range(0, 360, 45)] + ['0°']  # Add label for 360° (same as 0°)
    ax.set_thetagrids(np.degrees(angles), labels=angle_labels)
    ax.set_title('Ultrasound Distance Measurements (mm)')
    ax.set_rlabel_position(-22.5)  # Move radial labels

    # Show the plot
    plt.show()

data_array = []


while True: 

    data= ser.readline()
    #data = data.split('\n')[0].hex()
    if data != b'':
        # Decode byte string to regular string
        decoded_data = data.decode('utf-8')

        # Strip off whitespace and newlines
        stripped_data = decoded_data.strip()

        # Convert to integer
        value = int(stripped_data)
        data_array.append(value)
        print(value)
        print('Array: ',data_array)
        if len(data_array) % 8 == 0:
            plot_distance_simple(data_array[-8:])
        
        
