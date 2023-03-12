import tkinter as tk
from tkinter import ttk
import os
from pathlib import Path

class Application(tk.Frame):
    def __init__(self, master=None):
        super().__init__(master)
        self.master = master
        self.master.title("Perl Shell Command Runner")
        self.master.geometry("1100x700")
        self.master.resizable(False, False)
        self.create_widgets()

    def create_widgets(self):
        self.first_enter = [0,0,0]
        # Left frame for menu
        self.menu_frame = tk.Frame(self.master, bg="#333")
        self.menu_frame.pack(side="left", fill="y")

        self.add_first_menu()

        # Apply style to the menu options
        style = ttk.Style()
        style.configure("Bold.Treeview", foreground="black", font=("Arial", 16, "bold"))

        # Main frame for command and output
        self.main_frame = tk.Frame(self.master)
        self.main_frame.pack(side="left", fill="both", expand=True)

        # Output label and text box
        self.output_label = tk.Label(self.main_frame, text="Output:", font=("Arial", 16))
        self.output_label.pack(side="top", pady=20)
        self.output_text = tk.Text(self.main_frame, height=30, width=70, font=("Arial", 12),foreground = "white" ,wrap="word", bg="#222",borderwidth= 10)
        self.output_text.pack(side="top", padx=20, pady=5)

    def create_menu_lable(self):
        # Menu label
        self.menu_label = tk.Label(self.menu_frame, text="Menu", fg="#fff", bg="#333", font=("Arial", 30, "bold"))
        self.menu_label.pack(side="top", pady=30,padx=60)

    def add_first_menu(self):
        self.create_menu_lable()
        # Menu options
        button_style = ttk.Style()
        button_style.configure('my.TButton', font=('Helvetica', 16,'bold'),foreground ='black',background='gray')
        self.menu_options = ttk.Treeview(self.menu_frame)
        self.admin_button = ttk.Button(self.menu_frame, text = "Admin", style = 'my.TButton', command=self.admin_button)
        self.admin_button.pack(side="top", pady=20)

        self.system_button = ttk.Button(self.menu_frame, text = "System",style = 'my.TButton', command=self.system_button)
        self.system_button.pack(side="top", pady=20)

        self.shell_button = ttk.Button(self.menu_frame, text = "Shell", style = 'my.TButton', command=self.shell_button)
        self.shell_button.pack(side="top", pady=20)

    def clear_menu_frame(self):
        for widget in self.menu_frame.winfo_children():
            widget.forget()
        self.create_menu_lable()

    def submit_two_inputs(self,file):
        input1 = self.input1_text_field.get()
        input2 = self.input2_text_field.get()
        command = file + " " + input1 + " " + input2
        self.run_command(command)

    def pop_window_for_two_inputs(self,window_name,input1,input2,file):
        # Create a new window
        window = tk.Toplevel(root)
        window.title(window_name)
        window.resizable(False, False)
        window.configure(background="#222222")

        label1 = tk.Label(window, text=input1, fg="white", bg="#222222")
        label1.grid(row=0, column=0, padx=10, pady=5)

        # Create a text field
        self.input1_text_field = tk.Entry(window, bg="#444444", fg="white")
        self.input1_text_field.grid(row=1, column=0, padx=10, pady=5)

        label2 = tk.Label(window, text=input2, fg="white", bg="#222222")
        label2.grid(row=0, column=1, padx=10, pady=5)

        self.input2_text_field = tk.Entry(window, bg="#444444", fg="white")
        self.input2_text_field.grid(row=1, column=1, padx=10, pady=5)
        # Create a button
        button = tk.Button(window, text="Submit", command=lambda: (self.submit_two_inputs(file),window.destroy()), bg="#555555", fg="white")
        button.grid(row=2, column=0, columnspan=2, padx=10, pady=10)

    def submit_one_inputs(self,file):
        input1 = self.input1_text_field.get()
        command = file + " " + input1
        self.run_command(command)

    def pop_window_for_one_input(self,window_name,input1,file):
        # Create a new window
        window = tk.Toplevel(root)
        window.title(window_name)
        window.resizable(False, False)
        window.configure(background="#222222")

        label1 = tk.Label(window, text=input1, fg="white", bg="#222222")
        label1.grid(row=0, column=0, padx=10, pady=5)

        # Create a text field
        self.input1_text_field = tk.Entry(window, bg="#444444", fg="white")
        self.input1_text_field.grid(row=1, column=0, padx=10, pady=5)

        # Create a button
        button = tk.Button(window, text="Submit", command=lambda: (self.submit_one_inputs(file),window.destroy()), bg="#555555", fg="white")
        button.grid(row=2, column=0, columnspan=2, padx=10, pady=10)

    def admin_button(self):
        self.clear_menu_frame()
        if self.first_enter[0] == 0:
            button_style = ttk.Style()
            button_style.configure('my.TButton', font=('Helvetica', 16,'bold'),foreground ='black',background='gray')

            self.add_user_button = ttk.Button(self.menu_frame, text="Add User", style='my.TButton', command=self.add_user)
            self.add_user_button.pack(side="top", pady=20)

            self.remove_user = ttk.Button(self.menu_frame, text="Remove User", style='my.TButton', command=self.remove_user)
            self.remove_user.pack(side="top", pady=20)

            self.change_permissions = ttk.Button(self.menu_frame, text="Change Permissions", style='my.TButton', command=self.change_permissions)
            self.change_permissions.pack(side="top", pady=20)

            if 1 in self.first_enter:
                self.return_button.pack(side="top", pady=20)
            else:
                self.return_button = ttk.Button(self.menu_frame, text="Retun", style='my.TButton', command=self.return_button)
                self.return_button.pack(side="top", pady=20)
            self.first_enter[0] = 1
        else:
            self.add_user_button.pack(side="top", pady=20)
            self.remove_user.pack(side="top", pady=20)
            self.change_permissions.pack(side="top", pady=20)
            self.return_button.pack(side="top", pady=20)

    def system_button(self):
        self.clear_menu_frame()
        if self.first_enter[1] == 0:
            button_style = ttk.Style()
            button_style.configure('my.TButton', font=('Helvetica', 16,'bold'),foreground ='black',background='gray')

            self.process_monitor = ttk.Button(self.menu_frame, text="Process monitor", style='my.TButton', command=self.process_monitor)
            self.process_monitor.pack(side="top", pady=20)

            self.process_kill = ttk.Button(self.menu_frame, text="Process kill", style='my.TButton', command=self.process_kill)
            self.process_kill.pack(side="top", pady=20)

            self.backup = ttk.Button(self.menu_frame, text="Backup", style='my.TButton', command=self.backup)
            self.backup.pack(side="top", pady=20)

            if 1 in self.first_enter:
                self.return_button.pack(side="top", pady=20)
            else:
                self.return_button = ttk.Button(self.menu_frame, text="Retun", style='my.TButton', command=self.return_button)
                self.return_button.pack(side="top", pady=20)
            self.first_enter[1] = 1
        else:
            self.process_monitor.pack(side="top", pady=20)
            self.process_kill.pack(side="top", pady=20)
            self.backup.pack(side="top", pady=20)
            self.return_button.pack(side="top", pady=20)

    def shell_button(self):
        self.clear_menu_frame()
        if self.first_enter[2] == 0:
            button_style = ttk.Style()
            button_style.configure('my.TButton', font=('Helvetica', 16, 'bold'), foreground='black', background='gray')

            self.touch = ttk.Button(self.menu_frame, text="touch", style='my.TButton',command=self.touch)
            self.touch.pack(side="top", pady=10)

            self.cat = ttk.Button(self.menu_frame, text="cat", style='my.TButton',command=self.cat)
            self.cat.pack(side="top", pady=10)

            self.chmod = ttk.Button(self.menu_frame, text="chmod", style='my.TButton',command=self.chmod)
            self.chmod.pack(side="top", pady=10)

            self.cp = ttk.Button(self.menu_frame, text="cp", style='my.TButton',command=self.cp)
            self.cp.pack(side="top", pady=10)

            self.ls = ttk.Button(self.menu_frame, text="ls", style='my.TButton',command=self.ls)
            self.ls.pack(side="top", pady=10)

            self.mkdir = ttk.Button(self.menu_frame, text="mkdir", style='my.TButton',command=self.mkdir)
            self.mkdir.pack(side="top", pady=10)

            if 1 in self.first_enter:
                self.return_button.pack(side="top", pady=10)
            else:
                self.return_button = ttk.Button(self.menu_frame, text="Retun", style='my.TButton', command=self.return_button)
                self.return_button.pack(side="top", pady=10)
            self.first_enter[2] = 1
        else:
            self.touch.pack(side="top", pady=10)
            self.cat.pack(side="top", pady=10)
            self.chmod.pack(side="top", pady=10)
            self.cp.pack(side="top", pady=10)
            self.ls.pack(side="top", pady=10)
            self.mkdir.pack(side="top", pady=10)
            self.return_button.pack(side="top", pady=10)

    def return_button(self):
        for widget in self.menu_frame.winfo_children():
            widget.pack_forget()

        self.create_menu_lable()
        self.admin_button.pack(side="top", pady=20)
        self.system_button.pack(side="top", pady=20)
        self.shell_button.pack(side="top", pady=20)

    def add_user(self):
        self.pop_window_for_two_inputs("Add User","Username","Password","/admin/add_user.pl")

    def remove_user(self):
        self.pop_window_for_one_input("Remove User","Username","/admin/delete_user.pl")

    def change_permissions(self):
        self.pop_window_for_two_inputs("Change Permissions","Username","Permissions","/system/change_permissions.pl")

    def process_monitor(self):
        self.run_command("/system/process_monitoring.pl")

    def process_kill(self):
        self.pop_window_for_one_input("Process Kill","Process ID","/system/delete_user.pl")

    def backup(self):
        self.pop_window_for_two_inputs("Backup","Backup from","Backup to","/system/backup.pl")

    def cat(self):
        self.pop_window_for_one_input("cat","File Path","/shell/cat.pl")

    def chmod(self):
        self.pop_window_for_two_inputs("chmod","Mode [OCTA]","File","/shell/chmod.pl")

    def cp(self):
        self.pop_window_for_two_inputs("copy","From","To","/shell/cp.pl")

    def ls(self):
        self.pop_window_for_one_input("ls","Directory Path","/shell/ls.pl")

    def mkdir(self):
        self.pop_window_for_one_input("mkdir","Directory Path","/shell/mkdir.pl")

    def touch(self):
        self.pop_window_for_one_input("touch","File Path","/shell/touch.pl")


    def run_command(self,perl_script):
        path = str(Path.cwd()) + "/../perl_scripts" + str(perl_script)
        perl_output = os.popen(path).read()
        self.output_text.delete(1.0, tk.END)
        self.output_text.insert(tk.END, perl_output)


# Create the GUI application
root = tk.Tk()
app = Application(master=root)
app.mainloop()
