/**
* Object: obj_penguin | Event: Create
*/

player_speed_h = 0;
player_speed_v = 0;
player_speed_max = 1.6;
player_acceleration = 0.06;
player_deceleration = 0.04;
player_stop_movement_threshold = 60;
player_stop_vertical_movement_timing = 0;
player_stop_horizontal_movement_timing = 0;
image_speed = 0.5;

key_right = 0;
key_left = 0;
key_down = 0;
key_up = 0; 

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
            } else {
                player_speed_h -= player_deceleration;
            }
        } else if (player_speed_h < 0) {
            if (player_speed_h >= -player_deceleration) {
                player_speed_h = 0;
            } else {
                player_speed_h += player_deceleration;
            }
        }
    } else if (direction == "vertical") {
        if (player_speed_v > 0) {
            if (player_speed_v <= player_deceleration) {
                player_speed_v = 0;
            } else {
                player_speed_v -= player_deceleration;
            }
        } else if (player_speed_v < 0) {
            if (player_speed_v >= -player_deceleration) {
                player_speed_v = 0;
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
    var x_axis = sign(player_speed_h);
    var y_axis = sign(player_speed_v);
    var movement_direction = point_direction(0, 0, player_speed_h, player_speed_v);
    x_movement = lengthdir_x(abs(player_speed_h), movement_direction);
    y_movement = lengthdir_y(abs(player_speed_v), movement_direction);
    // spostamento orizzontale
    if (player_speed_h != 0) {
        var collision_on_ice_block_1 = instance_place(x + x_movement, y, obj_ice_block_1);
        var collision_on_ice_block_2 = instance_place(x + x_movement, y, obj_ice_block_2);
        var collision_on_ice_block_3 = instance_place(x + x_movement, y, obj_ice_block_3);
        if (collision_on_ice_block_1 == noone && collision_on_ice_block_2 == noone && collision_on_ice_block_3 == noone) {
            // nessuna collisione
            x += x_movement;
        } else {
            // collisione
            player_speed_h = 0;
            if (collision_on_ice_block_1 != noone) {
                x = collision_on_ice_block_1.x - (sprite_width * x_axis);
            } else if (collision_on_ice_block_2 != noone) {
                x = collision_on_ice_block_2.x - (sprite_width * x_axis);
            } else if (collision_on_ice_block_3 != noone) {
                x = collision_on_ice_block_3.x - (sprite_width * x_axis);
            }
        }
    }
    // spostamento verticale
    if (player_speed_v != 0) {
        var collision_on_ice_block_1 = instance_place(x, y + y_movement, obj_ice_block_1);
        var collision_on_ice_block_2 = instance_place(x, y + y_movement, obj_ice_block_2);
        var collision_on_ice_block_3 = instance_place(x, y + y_movement, obj_ice_block_3);
        if (collision_on_ice_block_1 == noone && collision_on_ice_block_2 == noone && collision_on_ice_block_3 == noone) {
            // nessuna collisione
            y += y_movement;
        } else {
            // collisione
            player_speed_v = 0;
            if (collision_on_ice_block_1 != noone) {
                y = collision_on_ice_block_1.y - (sprite_height * y_axis);
            } else if (collision_on_ice_block_2 != noone) {
                y = collision_on_ice_block_2.y - (sprite_height * y_axis);
            } else if (collision_on_ice_block_3 != noone) {
                y = collision_on_ice_block_3.y - (sprite_height * y_axis);
            }
        }
    }
}

function setAnimations() {
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