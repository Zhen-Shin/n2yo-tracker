extends Control
onready var Con = $ScrollContainer/VBoxContainer

#Examples 
#https://www.n2yo.com/sat/jtest.php?s=25544&r=403496066355.1447&callback=
#https://www.n2yo.com/sat/jtest.php?s=37849&r=1450768711162.4783&callback=
#https://www.n2yo.com/sat/jtest.php?s=33591&r=639757616296.737&callback=

func Get_Data():
	#Key parameters for the link
	var First_Parameter = "https://www.n2yo.com/sat/jtest.php?s="
	var Second_Parameter = "&callback="
	var Valid_Link = null
	
	var Add_Sat_Bool = null 
	var Sat_Instance = preload("res://Main.tscn").instance()
	var lowerCasecheck = $LineEdit.text
	
	#if the line editor has a empty or null value
	if $LineEdit.text != "":
		Add_Sat_Bool = true 
	elif $LineEdit.text == "":
		Add_Sat_Bool = false
		$LineEdit.text = str("Error!")
	
	#Check for certian keywords in the link
	if First_Parameter in $LineEdit.text && Second_Parameter in  $LineEdit.text:
		Valid_Link = true
	else: 
		Valid_Link = false
		$LineEdit.text = str("Error!")
	
	#If all the boolean came out as true add
	if Add_Sat_Bool == true && Valid_Link == true:
		Sat_Instance.Sat_URL = $LineEdit.text
		Con.add_child(Sat_Instance)

func _on_Button_pressed():
	Get_Data()
	Disable_Button(false)
	yield(get_tree().create_timer(5.0), "timeout")
	Disable_Button(true)
	yield(get_tree().create_timer(5.0), "timeout")


func Disable_Button(Can_Press):
	if Can_Press == false:
		$Button.disabled = true
		$LineEdit.editable = false
	elif Can_Press == true:
		$Button.disabled = false
		$LineEdit.editable = true
		$LineEdit.clear()
