
-- includes all the templates code ...
include "slider ctrlmaker_attributes.ms"
include "spinner ctrlmaker_attributes.ms"
include "slider with spinner ctrlmaker_attributes.ms"
include "transform spinners ctrlmaker_attributes.ms"

struct ctrlmkrCaSetUp_source (

	-- checks the attribute holder modifier...
	fn addHolder obj holderName = (
		
		holder = EmptyModifier name:holderName

		addModifier obj holder
		),

	-- filters the template list and builds the custom attribute definition...
	fn ca_build listArray rollName modIndex ca_setUpArray ca4_setUpArray = (

		-- starts the custom attribute definition...
		caStart = "ca = Attributes '" + rollName + "' (\nparameters '" + rollName + "' rollout:'" + rollName + "Ui' (\n"

		-- starts the rollout definition...
		caRollStart = ")\nrollout '" + rollName + "Ui' \"" + rollName + "\" (\n"

		-- creates the custom attribute variables for parameters, ui and counters...
		caParams = ""; caUi = ""; j = 1; ca= 1; ca4 = 1

		-- filters the template list to append the custom attribute parameters and ui...
		for listItem in listArray do (

			label1 = caSlider_source.attributeLabel
			label2 = caSpinner_source.attributeLabel
			label3 = caSliderWithSpinner_source.attributeLabel
			setUpCaUi = undefined

			-- "slider", "spinners", "slider with spinner" templates...
			if listItem == label1 or listItem == label2 or listItem == label3 do (
				
				ca_color = (ca_setUpArray[1])[ca]
				ca_name = (ca_setUpArray[2])[ca]
				ca_min = (ca_setUpArray[3])[ca]
				ca_max = (ca_setUpArray[4])[ca]
				ca_int = (ca_setUpArray[5])[ca]
				caS = ca as string

				if listItem == label1 do setUpCaUi = caSlider_source.caParamUi 
				if listItem == label2 do setUpCaUi = caSpinner_source.caParamUi 
				if listItem == label3 do setUpCaUi = caSliderWithSpinner_source.caParamUi 

				setUpItem = setUpCaUi caS rollName ca_color ca_name ca_min ca_max ca_int
					
				caParams += setUpItem[1]
				caUi += setUpItem[2]
				ca += 1
				)

			-- "transform spinners xyz" template..
			if listItem == caTransformSpinners_source.attributeLabel do (

				ca4_minArray = #((ca4_setUpArray[1])[j],(ca4_setUpArray[1])[j+1],(ca4_setUpArray[1])[j+2])
				ca4_maxArray = #((ca4_setUpArray[2])[j],(ca4_setUpArray[2])[j+1],(ca4_setUpArray[2])[j+2])
				ca4_prop = (ca4_setUpArray[3])[ca4]
				ca4S = ca4 as string; j+=3

				setUpItem4 = caTransformSpinners_source.caParamUi ca4S rollName ca4_minArray ca4_maxArray ca4_prop
				
				caParams += setUpItem4[1]
				caUi += setUpItem4[2]
				ca4 += 1
				)
			)

		-- ends the custom attribute definition and adds to the selected object first modifier...
		caEnd = ")\n)\ncustAttributes.add $.modifiers[" + modIndex as string + "] ca\nfree ca"
		caS = caStart + caParams + caRollStart + caUi + caEnd

		execute caS
		),

	fn setUpUi_build listArray = (
		
		roll1Start = \
			"rollout setUpModUi \"modifier setup\" width:210 (\n"+\
			--"group \" modifier selection: \" (\n"+\
			"dropdownlist ddl_mod \"\" items:#(\"new attribute holder\")\n"+\
			"editText mod_name \"\" text:\"---------- ctrlmaker ----------\" offset:[-2,0]\n"+\
			"imgTag img_sep1 bitmap:(bitmap 180 1 color:(color 10 10 10)) align:#center offset:[-1,0]\n"+\
			"button ceate_btn \"create custom attributes >\" width:180 offset:[-2,0]\n"

		-- starts the rollout definition...
		roll2Start = \
			"rollout setUpRollUi \"rollout setup\" width:210 (\n"+\
			"group \" rollout name: \" (\n"+\
			"editText roll_name \"\" text:\"my rollout\" height:16 align:#center offset:[-2,0]\n)\n"

		-- generate a random color for the tags...
		tagColor = random (color 0 0 0) (color 255 255 255)

		roll2PropGrp = ""; setUpS = ""; i = 1

		-- filters the template list builds the strings to setup the custom attributes...	
		for listItem in listArray do (

			iS = i as string
			tagColorS = tagColor as string
			label1 = caSlider_source.attributeLabel
			label2 = caSpinner_source.attributeLabel
			label3 = caSliderWithSpinner_source.attributeLabel
			label4 = caTransformSpinners_source.attributeLabel

			-- builds the strings to setup the custom attributes...	
			if listItem == label1 or listItem == label2 or listItem == label3 do (
				
				setUpS += \
					"append ca_colorArray roll.tag_color" + iS + ".color\n"+\
					"append ca_nameArray roll.sld_name" + iS + ".text\n"+\
					"append ca_minArray roll.ui_spn_min" + iS + ".value\n"+\
					"append ca_maxArray roll.ui_spn_max" + iS + ".value\n"+\
					"append ca_intArray roll.chk_" + iS + ".state\n"

				if listItem == label1 do roll2PropGrp += caSlider_source.setUpUiPrp iS tagColorS
				if listItem == label2 do roll2PropGrp += caSpinner_source.setUpUiPrp iS tagColorS
				if listItem == label3 do roll2PropGrp += caSliderWithSpinner_source.setUpUiPrp iS tagColorS

				tagColor = tagColor * 0.5
				)

			if listItem == label4 do (

				setUpS += \
					"append ca4_propArray roll.rdo_trm" + iS + ".state\n"+\
					"append ca4_minArray roll.ui_spnX_min" + iS + ".value\n"+\
					"append ca4_maxArray roll.ui_spnX_max" + iS + ".value\n"+\
					"append ca4_minArray roll.ui_spnY_min" + iS + ".value\n"+\
					"append ca4_maxArray roll.ui_spnY_max" + iS + ".value\n"+\
					"append ca4_minArray roll.ui_spnZ_min" + iS + ".value\n"+\
					"append ca4_maxArray roll.ui_spnZ_max" + iS + ".value\n"

				roll2PropGrp += caTransformSpinners_source.setUpUiPrp iS
				)

			i+=1
			)

		roll1EventGrp = \
			"on ddl_mod rightClick do (\n"+\
			"modArray = #()\n"+\
			"if selection.count == 1 do (\n"+\
			"for m in $.modifiers do append modArray m.name\n"+\
			"insertItem \"new attribute holder\" modArray 1)\nddl_mod.items = modArray\n)\n"+\
			"on ddl_mod selected mod do (\n"+\
			"if ddl_mod.selection == 1 then (mod_name.enabled = true; mod_name.visible = true)\n"+\
			"else (mod_name.enabled = false; mod_name.visible = false)\n)\n"+\
			-- creates all custom attributes...
			"on ceate_btn pressed do (\nroll = setUpFloater.rollouts[2]\n"+\
			"if selection.count == 1 then (\ni = 1\n"+\
			"if ddl_mod.selection == 1 do ctrlmkrCaSetUp_source.addHolder $ mod_name.text\n"+\
			-- a bunch of empty arrays...
			"ca_colorArray = #(); ca_nameArray = # (); ca_minArray = #(); ca_maxArray = #(); ca_intArray = #()\n"+\
			"ca4_minArray = #(); ca4_maxArray = #(); ca4_propArray = #()\n"+\
			-- creates all the setup arrays...
			setUpS +\
			"ca_setUpArray = #(ca_colorArray, ca_nameArray, ca_minArray, ca_maxArray, ca_intArray)\n"+\
			"ca4_setUpArray = #(ca4_minArray, ca4_maxArray, ca4_propArray)\n"+\
			-- creates all the custom attributes...
			"if ddl_mod.selection == 1 then ("+\
			"ctrlmkrCaSetUp_source.ca_build " + listArray as string + " roll.roll_name.text 1 ca_setUpArray ca4_setUpArray)\n"+\
			"else (ctrlmkrCaSetUp_source.ca_build " + listArray as string + " roll.roll_name.text (ddl_mod.selection - 1) "+\
			"ca_setUpArray ca4_setUpArray)\n)\nelse messageBox \"(づ｡◕‿‿◕｡)づ     select one object!\" "+\
			"title:\"ERROR: 49563879-1 CATASTROFIC FAILURE\"\n)\n)"

		-- builds the strings to setup the custom attributes...
		roll2End = \
			"group \" info: \" (\n"+\
			"label lab_credit1 \"set everything and click the big button\" align:#center)\n)\n"

		--rollEnd = "))createDialog setUpUi"
		rollFloater = \
			"setUpFloater = newRolloutFloater \"custom attributes setup\" 220 460\n"+\
			"addRollout setUpModUi setUpFloater\naddRollout setUpRollUi setUpFloater\n"

		-- concatenates all the strings...
		setUpUiS = roll1Start + roll1EventGrp + roll2Start + roll2PropGrp + roll2End + rollFloater

		execute setUpUiS
		)
	)

ctrlmkrCaSetUp_source = ctrlmkrCaSetUp_source()