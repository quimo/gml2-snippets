/**
* Object: obj_camera | Event: Create
*/

#macro viewport_width 640	
#macro viewport_height 480
#macro lerp_amount 0.05

// abilita la prima "vista"
view_enabled = true;
view_visible[0] = true;

// imposta le dimensioni della "vista"
view_xport[0] = 0;
view_yport[0] = 0;
view_wport[0] = viewport_width;
view_hport[0] = viewport_height;
 
// imposta una camera che "filma" quella vista
view_camera[0] = camera_create_view(0, 0, viewport_width, viewport_height, 0, -1, -1, -1, viewport_width/10, viewport_height/10);

// imposta la finestra di gioco al centro della viewport del monitor
var _dwidth = display_get_width();
var _dheight = display_get_height();
var _xpos = (_dwidth / 2) - viewport_width;
var _ypos = (_dheight / 2) - viewport_height;
window_set_rectangle(_xpos, _ypos, viewport_width, viewport_height);
surface_resize(application_surface, viewport_width, viewport_height);

/**
* Object: obj_camera | Event: Step
*/

// posizione attuale della camera
var current_camera_x = camera_get_view_x(view_camera[0]);
var current_camera_y = camera_get_view_y(view_camera[0]);

// posizione che la camera deve raggiungere (player sempre a centro schermo)
var camera_x = clamp(obj_penguin.x - (viewport_width/2), 0, room_width - viewport_width);
var camera_y = clamp(obj_penguin.y - (viewport_height/2), 0, room_height - viewport_height);

// sposta la camera "verso" la posizione del player con una interpolazione del 10% (segue in ritardo)
camera_set_view_pos(view_camera[0], lerp(current_camera_x, camera_x, lerp_amount), lerp(current_camera_y, camera_y, lerp_amount));

/**
* Object: obj_penguin | Event: Create
*/

player_speed_h = 0;
player_speed_v = 0;
player_speed_max = 2.6;
player_acceleration = 0.06;
player_deceleration = 0.1;
player_stop_movement_threshold = 60;
player_stop_vertical_movement_timing = 0;
player_stop_horizontal_movement_timing = 0;
image_speed = 0.5;
player_step_sound_interval = 0;
player_step_sound_timer = 7;
player_status = "still";
player_died = 0;

key_right = 0;
key_left = 0;
key_down = 0;
key_up = 0;

// recupera l'id del tile set presente sul layer "Water"
water_tileset = layer_tilemap_get_id(layer_get_id("Water"));

function setDecelerationTimer() {
    // timer per la decelerazione orizzontale
    if (key_right + key_left != 0) {
        // se sto premendo tasti di movimento il timer per la frenata si resetta
        player_stop_horizontal_movement_timing = 0;
    } else {
        // se non premo nessun tasto il timer scorre
        player_stop_horizontal_movement_timing++;
    }  
    // timer per la decelerazione verticale
    if (key_up + key_down != 0) {
        // se sto premendo tasti di movimento il timer per la frenata si resetta
        player_stop_vertical_movement_timing = 0;
    } else {
        // se non premo nessun tasto il timer scorre
        player_stop_vertical_movement_timing++;
    }
}

function horizontaldecelerationTimerReached() {
    if (player_stop_horizontal_movement_timing >= player_stop_movement_threshold) {
        return true;
    }
    return false;
}

function verticaldecelerationTimerReached() {
    if (player_stop_vertical_movement_timing >= player_stop_movement_threshold) {
        return true;
    }
    return false;
}

function decelerate(direction) {
    if (direction == "horizontal") {
        if (player_speed_h > 0) {
            if (player_speed_h <= player_deceleration) {
                player_speed_h = 0;
				player_speed_v = 0;
				if (player_status != "freezed") player_status = "still";
            } else {
                player_speed_h -= player_deceleration;
            }
        } else if (player_speed_h < 0) {
            if (player_speed_h >= -player_deceleration) {
                player_speed_h = 0;
				player_speed_v = 0;
				if (player_status != "freezed") player_status = "still";
            } else {
                player_speed_h += player_deceleration;
            }
        }
    } else if (direction == "vertical") {
        if (player_speed_v > 0) {
            if (player_speed_v <= player_deceleration) {
                player_speed_v = 0;
				player_speed_h = 0;
				if (player_status != "freezed") player_status = "still";
            } else {
                player_speed_v -= player_deceleration;
            }
        } else if (player_speed_v < 0) {
            if (player_speed_v >= -player_deceleration) {
                player_speed_v = 0;
				player_speed_h = 0;
				if (player_status != "freezed") player_status = "still";
            } else {
                player_speed_v += player_deceleration;
            }
        }
    }
}

function checkMovementAndSetSpeed() {
    if (key_right) {
        // accelero a destra
        if (player_speed_h < player_speed_max) player_speed_h += player_acceleration;
    }
        
    if (key_left) {
        // accelero a sinistra
        if (player_speed_h > -player_speed_max) player_speed_h -= player_acceleration;
    }

    if (key_up) {
        // accelero in alto
        if (player_speed_v > -player_speed_max) player_speed_v -= player_acceleration;
    }

    if (key_down) {
        // accelero in basso
        if (player_speed_v < player_speed_max) player_speed_v += player_acceleration;
    }
}

function move() {
    var movement_direction = point_direction(0, 0, player_speed_h, player_speed_v);
    x_movement = lengthdir_x(abs(player_speed_h), movement_direction);
    y_movement = lengthdir_y(abs(player_speed_v), movement_direction);
    // spostamento orizzontale
    if (player_speed_h != 0) {
		if (player_status != "freezed") player_status = "run";
		// collisione con oggetti
        var collision_on_ice_block_1 = instance_place(x + x_movement, y, obj_ice_block_1);
        var collision_on_ice_block_2 = instance_place(x + x_movement, y, obj_ice_block_2);
        var collision_on_ice_block_3 = instance_place(x + x_movement, y, obj_ice_block_3);
		// collisione con tiles
		if (player_speed_h > 0) {
			var hitpoint = bbox_right;
			// verifico se esiste una collisione agli estremi sopra e sotto della hitbox del player
			var collided_top = tilemap_get_at_pixel(water_tileset, hitpoint + x_movement, bbox_top);
			var collided_bottom = tilemap_get_at_pixel(water_tileset, hitpoint + x_movement, bbox_bottom);
		} else if (player_speed_h < 0) {
			var hitpoint = bbox_left;
			var collided_top = tilemap_get_at_pixel(water_tileset, hitpoint - x_movement, bbox_top);
			var collided_bottom = tilemap_get_at_pixel(water_tileset, hitpoint - x_movement, bbox_bottom);
		}
        if (collision_on_ice_block_1 == noone && collision_on_ice_block_2 == noone && collision_on_ice_block_3 == noone && collided_top == 0 && collided_bottom == 0) {
            // nessuna collisione con oggetti o con tile
			if (player_status != "freezed") x += x_movement;
        } else {
            // collisione
            if (collision_on_ice_block_1 != noone) {
				player_status = "bounced";
				player_speed_h = -player_speed_h/2;
            } else if (collision_on_ice_block_2 != noone) {
				player_status = "bounced";
				player_speed_h = -player_speed_h/2;
            } else if (collision_on_ice_block_3 != noone) {
				player_status = "bounced";
				player_speed_h = -player_speed_h/2;
            } else if (collided_top != 0 || collided_bottom != 0) {
				player_status = "freezed";
				if (player_died = 0) {		
					alarm[0] = room_speed;
					player_died = 1;
				}
			}
        }
    }
    // spostamento verticale
    if (player_speed_v != 0) {
		if (player_status != "freezed") player_status = "run";
		// collisione con oggetti
        var collision_on_ice_block_1 = instance_place(x, y + y_movement, obj_ice_block_1);
        var collision_on_ice_block_2 = instance_place(x, y + y_movement, obj_ice_block_2);
        var collision_on_ice_block_3 = instance_place(x, y + y_movement, obj_ice_block_3);
		// collisione con tiles
		if (player_speed_v > 0) {
			var hitpoint = bbox_bottom;
			// verifico se esiste una collisione agli estremi destra e sinistra della hitbox del player
			var collided_left = tilemap_get_at_pixel(water_tileset, bbox_left, hitpoint + y_movement);
			var collided_right = tilemap_get_at_pixel(water_tileset, bbox_right, hitpoint + y_movement);
		} else if (player_speed_v < 0) {
			var hitpoint = bbox_top;
			// verifico se esiste una collisione agli estremi destra e sinistra della hitbox del player
			var collided_left = tilemap_get_at_pixel(water_tileset, bbox_left, hitpoint - y_movement);
			var collided_right = tilemap_get_at_pixel(water_tileset, bbox_right, hitpoint - y_movement);
		}
        if (collision_on_ice_block_1 == noone && collision_on_ice_block_2 == noone && collision_on_ice_block_3 == noone && collided_left == 0 && collided_right == 0) {
            // nessuna collisione
			if (player_status != "freezed") y += y_movement;
        } else {
            // collisione
            if (collision_on_ice_block_1 != noone) {
				player_status = "bounced";
				player_speed_v = -player_speed_v/2;
            } else if (collision_on_ice_block_2 != noone) {
				player_status = "bounced";
				player_speed_v = -player_speed_v/2;
            } else if (collision_on_ice_block_3 != noone) {
				player_status = "bounced";
				player_speed_v = -player_speed_v/2;
            } else if (collided_left != 0 || collided_right != 0) {
				player_status = "freezed";
				if (player_died = 0) {		
					alarm[0] = room_speed;
					player_died = 1;
				}
			}
        }
    }
}

function setAnimations() {
	if (player_status != "freezed") {
	    if (key_right) {
	        sprite_index = spr_penguin_right;
	    }	
	    if (key_left) {
	        sprite_index = spr_penguin_left;
	    }
	    if (key_up) {
	        sprite_index = spr_penguin_up;
	    }
	    if (key_down) {
	        sprite_index = spr_penguin_down;
	    }
	    if (key_right + key_left + key_up + key_down != 0) {
	        image_speed = 0.5;
	    } else {
	        //image_index = 0;
	        if (player_speed_h == 0 && player_speed_v == 0) {
	            image_speed = 0.08;
	            sprite_index = spr_penguin_still;
	        } else {
	            image_speed = 0.5;
	            sprite_index = spr_penguin;
	        }
	    }
	} else {
		sprite_index = spr_penguin_freeze;
	}
}

function setSound() {
	// suono di passi
	if (player_step_sound_interval >= player_step_sound_timer) {
		player_step_sound_interval = 0;
		if (key_right + key_left + key_up + key_down != 0 && !player_died) {
			audio_play_sound(snd_steps, 10, false);
		}
	} else {
		player_step_sound_interval++;
	}
	// suono collisione
	if (player_status == "bounced") {
		audio_play_sound(snd_ice, 10, false);
		player_status = "still";
	}
}

/**
* Object: obj_penguin | Event: Step
*/

key_right = keyboard_check(vk_right);
key_left = keyboard_check(vk_left);
key_down = keyboard_check(vk_down);
key_up = keyboard_check(vk_up);

// timer per la decelerazione
setDecelerationTimer();

// controllo la pressione dei tasti di movimento e imposto la velocità
checkMovementAndSetSpeed();

// sposto il player
move();

// se il timer è stato raggiunto
if (horizontaldecelerationTimerReached()) {
	// decelero
	decelerate("horizontal");
}
// se il timer è stato raggiunto
if (verticaldecelerationTimerReached()) {
	// decelero
	decelerate("vertical");
}

// decido quale animazione mostrare
setAnimations();

// imposto i suoni
setSound();

/**
* Object: obj_penguin | Event: Alarm0
*/

player_status = "still";
game_restart();

