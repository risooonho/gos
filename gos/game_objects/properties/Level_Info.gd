extends Node

enum WIND_LEVELS {NONE, WEAK, MEDIUM, STRONG}


export (String) var level_name = ""
export (WIND_LEVELS) var wind_strength = 1
export (bool) var echo = false