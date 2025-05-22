import psutil
import time
import matplotlib.pyplot as plt

#Dashboards (using libraries like plotly or matplotlib)
This code fetches CPU usage and generates a simple plot (you'll need matplotlib installed: pip install matplotlib).

def monitor_and_plot_cpu():
    cpu_history = []
    time_history = []
    plt.ion() # Turn on interactive mode

    fig, ax = plt.subplots()
    line, = ax.plot(time_history, cpu_history)
    ax.set_xlabel("Time")
    ax.set_ylabel("CPU Usage (%)")
    ax.set_title("Real-time CPU Usage")

    start_time = time.time()
    try:
        while True:
            cpu_percent = psutil.cpu_percent()
            current_time = time.time() - start_time
            cpu_history.append(cpu_percent)
            time_history.append(current_time)

            line.set_xdata(time_history)
            line.set_ydata(cpu_history)
            ax.relim()
            ax.autoscale_view()
            fig.canvas.draw()
            fig.canvas.flush_events()

            time.sleep(1)
    except KeyboardInterrupt:
        print("Monitoring stopped.")

if __name__ == "__main__":
    monitor_and_plot_cpu()