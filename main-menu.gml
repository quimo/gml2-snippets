/**
* Object: obj_menu | Event: Create
*/

item_height = 32;
items_index = 0;


items = [
	"New Game",
	"Exit",
]; 

items_number = array_length(items);

/**
* Object: obj_menu | Event: Step
*/

var menu_movement = 0;
menu_movement = keyboard_check_pressed(vk_down) - keyboard_check_pressed(vk_up);
if (menu_movement != 0) audio_play_sound(obj_sound_menu, 10, false);
items_index += menu_movement;

if (items_index >= items_number) items_index = 0;
if (items_index < 0) items_index = items_number - 1;

if (keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_enter)) {
	switch (items_index) {
		case 0:
			room_goto(1);
			break;
		case 1:
			game_end();
	}
}

/**
* Object: obj_menu | Event: Draw GUI
* l'evento draw viene eseguito ad ogni evento step:
* 1) default draw: su tutti gli oggetti della room che possiedono
* uno sprite (l'evento draw lo disegna) e hanno settato il flag "visible"
* 2) custom draw: quando viene inserito del codice nell'evento stesso questo
* viene eseguito e sovrascrive il "default draw" (l'eventuale sprite associato
* all'oggetto non viene disegnato)
*/

draw_set_font(obj_font_menu);
draw_set_halign(fa_center);
for (var i = 0; i < items_number; i++) {
	draw_set_color($ffffff);
	if (items_index == i) draw_set_color($ff0000);
	draw_text(x, y + (item_height * i), items[i]);
}