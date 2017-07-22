include "generic slider with spinner attributes.ms"
include "transform spinner attributes.ms"

-- try to closes any instance of the main ui rollout...
try(destroyDialog ctrlmakerMainUi)catch()

struct ctrlmkr_source (
	
	-- checks the attribute holder modifier...
	fn checkHolder obj holderName = (
		if obj.modifiers[holderName] == undefined do (addModifier $ (EmptyModifier name:holderName))
		),

	-- main ui rollout...
	fn mainUi = (
		rollout ctrlmakerMainUi "ctrlmaker" width:210 (
			group "generic slider with spinner: " (
				label lab_radio "channels:" align:#left offset:[0,4]
				radioButtons rdo_ui "" labels:#("1","2","3","4") default:1 columns:4 align:#right offset:[0,-18]
				button set_btn1 "set parameters" width:180 height:30 align:#right offset:[0,4]
				)
			group "transform spinners: " (
				checkbox ch_pos_ui "position" checked:true align:#left offset:[0,4] across:3
				checkbox ch_rot_ui "rotation" checked:true align:#center offset:[10,4]
				checkbox ch_scale_ui "scale" checked:true align:#right offset:[5,4]
				button set_btn2 "set parameters" width:180 height:30 align:#right offset:[0,4]
				)
			group "delete rollout:" (
				spinner del_spn1 "" range:[1,999,1] type:#integer fieldWidth:60 align:#left offset:[0,10] across:2
				button del_btn1 "remove" width:90 height:30
				)
			group "abaut: " (
				label lab_credit1 "ctrlmaker v3" across:2 align:#left
				hyperLink link_credit "pointlesspineapple.com" address:"https://www.pointlesspineapple.com/" align:#right
				)
			-- event handlers...
			on set_btn1 pressed do (
				ctrlmkr_source.checkHolder $ "---------- Ctrls ----------"
				gernericSliderWithSpinnerAttributes_source.buildUi 1 "roll name" #(blue) #("ctrl name 1") #(-100) #(100)
				)
			on set_btn2 pressed do (
				ctrlmkr_source.checkHolder $ "---------- Ctrls ----------"
				transformSpinnerAttributes_source.buildUi "roll name" true true true -10 10 -10 10 -10 10 -90 90 -90 90 -90 90 0.01 2 0.01 2 0.01 2
				)
			--on del_btn1 pressed do
			)
		createDialog ctrlmakerMainUi
		)
	)

ctrlmkr_source = ctrlmkr_source()

ctrlmkr_source.mainUi()