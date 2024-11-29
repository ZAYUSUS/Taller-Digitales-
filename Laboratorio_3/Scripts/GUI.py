import tkinter as tk
from tkinter import ttk
from Conversor import CONVERTER
from Sender import Sender

class GUI:
    window = tk.Tk()
    converter = CONVERTER()
    E_name = tk.Entry(window)
    T_box = T = tk.Text(window, height = 15, width = 52)
    sender = Sender()
    
    def __init__(self): # Constructor
        print("Convertidor Iniciado...")
        self.init_Window()
        self.init_Entries()
        self.init_Buttons()
        self.init_Labels()
        self.init_Text()
        self.window.mainloop()
        
    def init_Window(self):
        self.window.title("Uart")
        self.window.geometry('700x500')
        self.window.columnconfigure((0,1),weight=1)
        self.window.rowconfigure((0,1),weight=1)
        self.window.rowconfigure(2,weight=4)
        self.window.rowconfigure(4,weight=10)
        self.window.configure(background="#243536")

    def init_Labels(self):
        I_name = tk.Label(text="Nombre Imagen: ")
        I_name.grid(row=0,column=0)
        
    def init_Entries(self):
        self.E_name.grid(row=0,column=1)
    def init_Text(self):
        self.T_box.grid(row=4,column=0)
        self.T_box.configure(state=tk.DISABLED)
    def init_Buttons(self):
        b_enviar = tk.Button(text="ENVIAR",
                width=20,
                height=5,
                bg="#2B3333",
                fg="white",
                command=self.send_data)
        b_enviar.grid(row=2,column=1)
        b_inicio = tk.Button(text="CI 2",
                width=5,
                height=2,
                bg="#2B3333",
                fg="white",
                command=self.send_begin)
        b_inicio.grid(row=3,column=1)
    def send_data(self):
        data  = self.converter.Create_Bin_Text(self.E_name.get()+".png")
        self.sender.send(data)
    def send_begin(self):
        p = "2"
        self.sender.send(p)