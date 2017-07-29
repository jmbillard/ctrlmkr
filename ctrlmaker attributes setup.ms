
-- includes all the templates code ...
include "slider ctrlmaker_attributes.ms"
include "spinner ctrlmaker_attributes.ms"
include "slider with spinner ctrlmaker_attributes.ms"
include "transform spinners ctrlmaker_attributes.ms"

struct ctrlmkrCaSetUp_source (

	setUpFloater = undefined,

	-- checks the attribute holder modifier...
	fn addHolder obj holderName = (

		holder = EmptyModifier name:holderName

		addModifier obj holder
		),

	-- filters the template list and builds the custom attribute definition...
	fn ca_build listArray rollName modIndex defIndex ca_setUpArray ca4_setUpArray = (
 
		
		redef = ""
		
		if defIndex > 1 do redef = \
			"\nredefine:(custAttributes.getDef "+\
			"$.modifiers[" + modIndex as string + "] " + (defIndex - 1) as string + ")"

		-- starts the custom attribute definition...
		caStart =\
			"ca = Attributes '" + rollName + "' " + redef + " (\n"+\
			"parameters '" + rollName + "' rollout:'" + rollName + "Ui' (\n"

		-- starts the rollout definition...
		caRollStart = ")\nrollout '" + rollName + "Ui' \"" + rollName + "\" (\n"

		-- creates the custom attribute variables for parameters, ui and counters...
		caParams = ""; caUi = "" 

		label1 = caSlider_source.attributeLabel
		label2 = caSpinner_source.attributeLabel
		label3 = caSliderWithSpinner_source.attributeLabel
		label4 = caTransformSpinners_source.attributeLabel

		-- filters the template list to append the custom attribute parameters and ui...
		ca = 1; j = 1; ca4 = 1; for listItem in listArray do (

			setUpCaUi = ""

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
			if listItem == label4 do (

				ca4_minArray = #((ca4_setUpArray[1])[j],(ca4_setUpArray[1])[j+1],(ca4_setUpArray[1])[j+2])
				ca4_maxArray = #((ca4_setUpArray[2])[j],(ca4_setUpArray[2])[j+1],(ca4_setUpArray[2])[j+2])
				ca4_prop = (ca4_setUpArray[3])[ca4]
				ca4S = ca4 as string

				setUpItem4 = caTransformSpinners_source.caParamUi ca4S rollName ca4_minArray ca4_maxArray ca4_prop

				caParams += setUpItem4[1]
				caUi += setUpItem4[2]
				ca4 += 1; j+=3
				)
			)

		-- ends the custom attribute definition and adds to the selected object first modifier...
		caEnd = ")\n)\ncustAttributes.add $.modifiers[" + modIndex as string + "] ca\nfree ca"
		caS = caStart + caParams + caRollStart + caUi + caEnd

		execute caS
		),

	fn setUpUi_build windowPos listArray tagColor1 tagColor2 = (

		ctrlmkrCaSetUp_source.setUpFloater = newRolloutFloater "custom attributes setup..." 220 600
		ctrlmkrCaSetUp_source.setUpFloater.pos = windowPos + [250, 0]
		modArray = "#(\"new attribute holder\", \"selected modifier\")"

		roll1Start = \
			"rollout setUpModUi \"modifier setup\" width:210 (\n"+\
			"dropdownlist ddl_mod \"\" items:" + modArray + "\n"+\
			"editText mod_name \"\" text:\"---------- ctrlmaker ----------\" offset:[-2,0]\n"+\
			"listbox list_def \"\" items:#() height:3 offset:[0,-20] enabled:false visible:false\n"+\
			"imgTag img_sep1 bitmap:(bitmap 180 1 color:(color 10 10 10)) align:#center offset:[-1,0]\n"+\
			"button ceate_btn \"create custom attributes >\" width:180 offset:[-2,0]\n\n"+\
			-----------------------------------------------------------------------------------------------------
			"fn updateDefList = (\nlist_def.items = #()\n"+\
			"if (selection as array).count == 1 and $.modifiers[1] != undefined do (\n"+\
			"modIndex = modPanel.getModifierIndex $ (modPanel.getCurrentObject())\n"+\
			"defList = ctrlmkrMain_source.getCaName $ modIndex #(\"new definition\")\n"+\
			"list_def.items = defList)\n)\n"

		-- starts the rollout definition...
		roll2Start = \
			"rollout setUpRollUi \"rollout setup\" width:210 (\n"+\
			"group \" rollout name: \" (\n"+\
			"editText roll_name \"\" text:\"my rollout\" height:16 align:#center offset:[-2,0]\n)\n"

		label1 = caSlider_source.attributeLabel
		label2 = caSpinner_source.attributeLabel
		label3 = caSliderWithSpinner_source.attributeLabel
		label4 = caTransformSpinners_source.attributeLabel

		-- generate a random color for the tags...
		i = 0; for l in listArray do if l == label1 or l == label2 or l == label3 do i += 1

		colorStep = (tagColor2 - tagColor1) / (i - 1)
		roll2PropGrp = ""; setUpS = ""; floaterHight = 262

		-- filters the template list builds the strings to setup the custom attributes...	
		i = 1; for listItem in listArray do (

			iS = i as string
			tagColorS = tagColor1 as string


			-- builds the strings to setup the custom attributes...	
			if listItem == label1 or listItem == label2 or listItem == label3 do (

				floaterHight += 67
				tagColor1 += colorStep
				setUpS += \
					"append ca_colorArray roll.tag_color" + iS + ".color\n"+\
					"append ca_nameArray roll.sld_name" + iS + ".text\n"+\
					"append ca_minArray roll.ui_spn_min" + iS + ".value\n"+\
					"append ca_maxArray roll.ui_spn_max" + iS + ".value\n"+\
					"append ca_intArray roll.chk_" + iS + ".state\n"

				if listItem == label1 do roll2PropGrp += caSlider_source.setUpUiPrp iS tagColorS
				if listItem == label2 do roll2PropGrp += caSpinner_source.setUpUiPrp iS tagColorS
				if listItem == label3 do roll2PropGrp += caSliderWithSpinner_source.setUpUiPrp iS tagColorS
				)

			if listItem == label4 do (

				floaterHight += 79
				roll2PropGrp += caTransformSpinners_source.setUpUiPrp iS
				setUpS += \
					"append ca4_propArray roll.rdo_trm" + iS + ".state\n"+\
					"append ca4_minArray roll.ui_spnX_min" + iS + ".value\n"+\
					"append ca4_maxArray roll.ui_spnX_max" + iS + ".value\n"+\
					"append ca4_minArray roll.ui_spnY_min" + iS + ".value\n"+\
					"append ca4_maxArray roll.ui_spnY_max" + iS + ".value\n"+\
					"append ca4_minArray roll.ui_spnZ_min" + iS + ".value\n"+\
					"append ca4_maxArray roll.ui_spnZ_max" + iS + ".value\n"
				)

			i += 1
			)

		-- all the empty empty arrays...
		emptyArrayS = \
			"ca_colorArray = #(); ca_nameArray = # (); ca_minArray = #(); ca_maxArray = #(); ca_intArray = #()\n"+\
			"ca4_minArray = #(); ca4_maxArray = #(); ca4_propArray = #()\n"

		setupArrayS = \
			"ca_setUpArray = #(ca_colorArray, ca_nameArray, ca_minArray, ca_maxArray, ca_intArray)\n"+\
			"ca4_setUpArray = #(ca4_minArray, ca4_maxArray, ca4_propArray)\n"

		roll1EventGrp = \
			"on ddl_mod selected mod do (\n"+\
			"if ddl_mod.selection == 1 then (\n"+\
			"mod_name.enabled = true; mod_name.visible = true\n"+\
			"list_def.enabled = false; list_def.visible = false\n)\n"+\
			-----------------------------------------------------------------------------------------------------
			"else (mod_name.enabled = false; mod_name.visible = false; "+\
			"list_def.enabled = true; list_def.visible = true\nupdateDefList()\n)\n)\n"+\
			-- updates the defList...
			"on list_def rightClick do updateDefList()\n"+\
			-- creates all custom attributes...
			"on ceate_btn pressed do (\n"+\
			"roll = ctrlmkrCaSetUp_source.setUpFloater.rollouts[2]; defIndex = 1\n"+\
			-----------------------------------------------------------------------------------------------------
			"if (selection as array).count == 1 then (\ni = 1; modIndex = 1\n"+\
			-----------------------------------------------------------------------------------------------------
			"if ddl_mod.selection == 1 or $.modifiers[1] == undefined do "+\
			"ctrlmkrCaSetUp_source.addHolder $ mod_name.text\n"+\
			-- crates and populates all the setup arrays...
			emptyArrayS + setUpS + setupArrayS +\
			-----------------------------------------------------------------------------------------------------
			"if ddl_mod.selection == 2 do (\n"+\
			"mod = modPanel.getCurrentObject()\n"+\
			"modIndex = modPanel.getModifierIndex $ mod\n"+\
			"defIndex = list_def.selection\n)\n"+\
			-----------------------------------------------------------------------------------------------------
			"ctrlmkrCaSetUp_source.ca_build " + listArray as string + " roll.roll_name.text "+\
			"modIndex defIndex ca_setUpArray ca4_setUpArray\n"+\
			"closeRolloutFloater ctrlmkrCaSetUp_source.setUpFloater)\n"+\
			-----------------------------------------------------------------------------------------------------
			"else messageBox \"(づ｡◕‿‿◕｡)づ     select one object!\" "+\
			"title:\"ERROR: 49563879-1  ||  CATASTROFIC FAILURE\"\n)\n)"

		roll2End = \
			"group \" info: \" (\n"+\
			"label lab_credit1 \"set everything and click the big button\" align:#center)\n)\n"

		-- concatenates all the strings...	
		rollout1 = execute (roll1Start + roll1EventGrp)
		rollout2 = execute (roll2Start + roll2PropGrp + roll2End)

		if floaterHight < 650 do setUpFloater.size = [220, floaterHight]
		
		addRollout rollout1 setUpFloater
		addRollout rollout2 setUpFloater
		)
	)

ctrlmkrCaSetUp_source = ctrlmkrCaSetUp_source()