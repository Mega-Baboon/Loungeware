difficulties = [
	{total: 4, angle: 45, canBackwards: false, shots: 6},
	{total: 5, angle: 45, canBackwards: false, shots: 6},
	{total: 6, angle: 45, canBackwards: false, shots: 6},
	{total: 7, angle: 45, canBackwards: false, shots: 6},
	{total: 8, angle: 45, canBackwards: false, shots: 6},
];

_difficulty = difficulties[2];

totalShots = _difficulty.shots;
totalTargets = _difficulty.total;

shotsLeft = totalShots;

active = true;

scope_manager = instance_create_layer(x, y, "Manager", jdllama_target_obj_scope_mgr);
shot_manager = instance_create_layer(238, 158, "Manager", jdllama_target_obj_shots_mgr);
with instance_create_layer(x, y, "Manager", jdllama_target_obj_target_mgr) {
	difficulty = other._difficulty;
}

_step = function() {
	shot_manager.shots = shotsLeft;
	if(active == true) {
		if(TIME_REMAINING < 60) {
			if((totalShots == shotsLeft) && (totalTargets == instance_number(jdllama_target_obj_target))) {
				instance_create_layer(120, 80, "Message", jdllama_target_obj_msg_pacifist)
				microgame_win();
				active = false;
			}
		}
		if(KEY_PRIMARY_PRESSED || KEY_SECONDARY_PRESSED) {
			if(shotsLeft > 0) {
				var scope = jdllama_target_obj_scope_mgr.middleScope;
				if(jdllama_target_obj_scope_mgr.leftScope.scopeActive == true) {
					scope = jdllama_target_obj_scope_mgr.leftScope;
				}
				else if(jdllama_target_obj_scope_mgr.rightScope.scopeActive == true) {
					scope = jdllama_target_obj_scope_mgr.rightScope;
				}
				with scope {
					if(place_meeting(x, y, jdllama_target_obj_target)) {
						var inst = instance_place(x, y, jdllama_target_obj_target);
						instance_destroy(inst);
						sfx_play(jdllama_target_snd_shot_good,1.2,false);
					}
					else {
						sfx_play(jdllama_target_snd_shot_bad,1.2,false);
						other.shotsLeft--;
						if(other.shotsLeft <= 0) {
							microgame_fail();
							active = false;
						}
					}
				}
				if(instance_number(jdllama_target_obj_target) <= 0) {
					microgame_win();
					active = false;
				}
			}
			
		}
	}
	
}