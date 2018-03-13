import sys
sys.path.append("api")
import LocalMachine
import GeneralElements
import ConsoleParameters

def get_mem_usage():
    mem_total = LocalMachine.run_command_safe("sudo cat /proc/meminfo | grep 'MemTotal' | tr -dc '0-9'")
    mem_available = LocalMachine.run_command_safe("sudo cat /proc/meminfo | grep 'MemAvailable' | tr -dc '0-9'")
    mem_free = LocalMachine.run_command_safe("sudo cat /proc/meminfo | grep 'MemFree' | tr -dc '0-9'")
    available_percent = (float(int(mem_total) - int(mem_available)) / float(mem_total)) * 100
    available_percent = '%.1f' % available_percent
    return float(available_percent), mem_total, mem_available, mem_free

def create_printout(separator="#", char_width=80):
    text = GeneralElements.header_bar(" MEM USAGE ", char_width, separator)
    mem_usage_percent, total, available, free = get_mem_usage()

    text += " Total: {} Mb Available: {} Mb Free: {} Mb\n".format(int(total)/1024, int(available)/1024, int(free)/1024)
    text += GeneralElements.indicator_bar(mem_usage_percent, dim="%", pre_text="MEM", char_width=char_width)
    return text

if __name__ == "__main__":
    rowcol = ConsoleParameters.console_rows_columns()
    print(create_printout(char_width=rowcol[1]))
