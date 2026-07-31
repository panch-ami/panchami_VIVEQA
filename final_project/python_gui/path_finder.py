import pygame
import serial
import time

# --- Configuration ---
COM_PORT = 'COM15'  # Change to your actual COM port
BAUD_RATE = 9600
IMAGE_FILE = 'map_bg.png'
FPGA_CLOCK_HZ = 24_000_000  # board runs at 24 MHz -- used to convert cycles -> time

# --- Town Pixel Coordinates (X, Y) mapped directly from MS Paint ---
TOWN_COORDS = {
    "Udupi": (129, 218),
    "Brahmvar": (133, 120),
    "Manipal": (221, 215),
    "Hiriydka": (263, 213),
    "Hiriydkaa": (263, 213),
    "Seethndi": (435, 77),
    "Seethndii": (435, 77),
    "Agumbe": (493, 57),
    "Karkala": (396, 368),
    "Shirva": (219, 361),
    "Belman": (271, 415),
    "Padubdri": (163, 444),
    "Padubdrii": (163, 444),
    "Manglore": (263, 727),
    "Mangloree": (263, 727),
    "Moodbdre": (406, 525),
    "Moodbdree": (406, 525),
    "Ujire": (761, 605),
    "Dharmstl": (817, 649),
    "Dharmstll": (817, 649),
    "Kinngoli": (261, 529),
    "Kinngolii": (261, 529),
    "Cherkady": (253, 127),
    "Cherkadyy": (253, 127)
}

# --- Display Labels Mapping ---
DISPLAY_LABELS = {
    "Udupi": "0: Udupi",
    "Brahmvar": "1: Brahmavar",
    "Manipal": "2: Manipal",
    "Hiriydka": "3: Hiriyadka",
    "Seethndi": "4: Seethanadi",
    "Agumbe": "5: Agumbe",
    "Karkala": "6: Karkala",
    "Shirva": "7: Shirva",
    "Belman": "8: Belman",
    "Padubdri": "9: Padubidri",
    "Manglore": "A: Manglore",
    "Moodbdre": "B: Moodbidre",
    "Ujire": "C: Ujire",
    "Dharmstl": "D: Dharmasthala",
    "Kinngoli": "E: Kinnigoli",
    "Cherkady": "F: Cherkady"
}

# --- Custom Label Offsets (X_offset, Y_offset) ---
LABEL_OFFSETS = {
    "Manipal": (-10, 15),
    "Hiriydka": (10, -15),
    "Seethndi": (10, 15),
    "Agumbe": (10, -15),
    "Udupi": (-50, -20)
}

# --- Initialize Pygame & Fonts ---
pygame.init()
pygame.font.init()

font = pygame.font.SysFont('Arial', 18, bold=True)
info_font = pygame.font.SysFont('Arial', 22, bold=True)

bg_image = pygame.image.load(IMAGE_FILE)
WIDTH, HEIGHT = bg_image.get_width(), bg_image.get_height()
screen = pygame.display.set_mode((WIDTH, HEIGHT))
pygame.display.set_caption("FPGA Hardware Route Finder")

# --- Initialize Serial ---
try:
    ser = serial.Serial(COM_PORT, BAUD_RATE, timeout=0.1)
    print(f"Connected to {COM_PORT}")
except Exception as e:
    print(f"Failed to connect to UART: {e}")
    ser = None

current_route = []
last_distance_km = None    # parsed from the "XX km" line
last_calc_cycles = None    # parsed from the "| 1234 cyc" line
last_calc_time_ms = None   # computed from cycles / FPGA_CLOCK_HZ

# --- Main Loop ---
running = True
while running:
    # 1. Handle Window Closing
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False

    # 2. Read UART Data
    if ser and ser.in_waiting > 0:
        try:
            raw_line = ser.readline().decode('utf-8').strip()

            if "->" in raw_line:
                print(f"Raw Route Received: {raw_line}")
                parts = raw_line.split("->")

                parsed_nodes = []
                for i, part in enumerate(parts):
                    clean_str = part.strip()
                    if i == len(parts) - 1:
                        # last segment looks like "Manglore   52 km" -- grab both
                        tokens = clean_str.split()
                        clean_str = tokens[0]
                        # try to pull the distance number out too, e.g. "52"
                        for tok in tokens[1:]:
                            if tok.isdigit():
                                last_distance_km = int(tok)
                                break

                    if clean_str in TOWN_COORDS:
                        parsed_nodes.append(clean_str)

                current_route = parsed_nodes
                print(f"Mapped Route: {current_route}")

            elif "cyc" in raw_line:
                # Expected format: "| 1234 cyc"
                print(f"Raw Cycle Line: {raw_line}")
                tokens = raw_line.replace("|", "").split()
                for tok in tokens:
                    if tok.isdigit():
                        last_calc_cycles = int(tok)
                        last_calc_time_ms = (last_calc_cycles / FPGA_CLOCK_HZ) * 1000.0
                        break

        except UnicodeDecodeError:
            pass

    # 3. Draw Background
    screen.blit(bg_image, (0, 0))

    # 4. Draw Town Labels on the Map
    for town_key, label_text in DISPLAY_LABELS.items():
        if town_key in TOWN_COORDS:
            x, y = TOWN_COORDS[town_key]
            dx, dy = LABEL_OFFSETS.get(town_key, (10, -10))
            text_surface = font.render(label_text, True, (0, 0, 0), (255, 255, 255))
            screen.blit(text_surface, (x + dx, y + dy))
            pygame.draw.circle(screen, (0, 0, 0), (x, y), 4)

    # 5. Draw Route Lines
    if len(current_route) >= 2:
        for i in range(len(current_route) - 1):
            start_node = current_route[i]
            end_node = current_route[i + 1]
            start_pos = TOWN_COORDS[start_node]
            end_pos = TOWN_COORDS[end_node]
            pygame.draw.line(screen, (0, 0, 255), start_pos, end_pos, 5)
            pygame.draw.circle(screen, (255, 0, 0), start_pos, 8)
            pygame.draw.circle(screen, (255, 0, 0), end_pos, 8)

    # 6. Draw the info panel (distance + calculation time)
    panel_lines = []
    if last_distance_km is not None:
        panel_lines.append(f"Distance: {last_distance_km} km")
    if last_calc_time_ms is not None:
        panel_lines.append(f"Calc Time:     {last_calc_time_ms:.3f} ms")

    if panel_lines:
        panel_width = 260
        panel_height = 24 * len(panel_lines) + 16
        panel_surface = pygame.Surface((panel_width, panel_height))
        panel_surface.fill((20, 20, 20))
        panel_surface.set_alpha(210)
        screen.blit(panel_surface, (10, 10))

        for i, line in enumerate(panel_lines):
            text_surface = info_font.render(line, True, (0, 255, 120))
            screen.blit(text_surface, (20, 18 + i * 24))

    # 7. Update Screen
    pygame.display.flip()

# --- Cleanup ---
if ser:
    ser.close()
pygame.quit()
