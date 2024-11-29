import serial


class Sender:
    ser = serial.Serial("COM6", 115200)
    
    def __init__(self): # Constructor
        print("Sender Iniciado...")
    
    def send(self,data):
        # Send character 'S' to start the program
        self.ser.write(data.encode())
        print(data.encode())
    def listen(self):
        return self.ser.readline()