struct ctrlmkrCaSetUp_source (

	-- filters the template list and builds the custom attribute definition...
	fn ca_build listArray rollName ca1_setUpArray ca2_setUpArray = (

		-- starts the custom attribute definition...
		caStart = "ca = Attributes '" + rollName + "' (\nparameters '" + rollName + "' rollout:'" + rollName + "Ui' (\n"
		-- starts the rollout definition...
		caRollStart = ")\nrollout '" + rollName + "Ui' \"" + rollName + "\" (\n"

		-- creates the custom attribute variables for parameters, ui and counters...
		caParams = ""; caUi = ""; j = 1; ca1= 1; ca2 = 1

		-- filters the template list to append the custom attribute parameters and ui...
		for listItem in listArray do (

			-- "slider with spinner" template..
			if listItem == caSliderWithSpinner_source.attributeLabel do (
			
				-- all the caParamUi arguments for this template...
				ca1_color = (ca1_setUpArray[1])[ca1]
				ca1_name = (ca1_setUpArray[2])[ca1]
				ca1_min = (ca1_setUpArray[3])[ca1]
				ca1_max = (ca1_setUpArray[4])[ca1]
				ca1S = ca1 as string

				setUpItem1 = caSliderWithSpinner_source.caParamUi ca1S rollName ca1_color ca1_name ca1_min ca1_max
				
				caParams += setUpItem1[1]
				caUi += setUpItem1[2]

				ca1 += 1
				)
			-- "transform spinners xyz" template..
			if listItem == caTransformSpinners_source.attributeLabel do (

				-- all the caParamUi arguments for this template...
				ca2_minArray = #((ca2_setUpArray[1])[j],(ca2_setUpArray[1])[j+1],(ca2_setUpArray[1])[j+2])
				ca2_maxArray = #((ca2_setUpArray[2])[j],(ca2_setUpArray[2])[j+1],(ca2_setUpArray[2])[j+2])
				ca2_prop = (ca2_setUpArray[3])[ca2]
				ca2S = ca2 as string; j+=3

				setUpItem2 = caTransformSpinners_source.caParamUi ca2S rollName ca2_minArray ca2_maxArray ca2_prop
				
				caParams += setUpItem2[1]
				caUi += setUpItem2[2]

				ca2 += 1
				)
			)

		-- ends the custom attribute definition and adds to the selected object first modifier...
		caEnd = ")\n)\ncustAttributes.add $.modifiers[1] ca\nfree ca"

		caS = caStart + caParams + caRollStart + caUi + caEnd
		execute caS
		--print caS
		),

	fn setUpUi_build listArray = (
		
		-- starts the rollout definition...
		rollStart = "rollout setUpUi \"ui properties\" width:210\n(\n"
		
		-- describes the first group...
		rollGrp = \
			"group \" modifier selection: \" (\n"+\
			"dropdownlist ddl_mod \"\" items:#() enabled:false)"+\
			"group \" rollout name: \" (\n"+\
			"editText roll_name \"\" text:\"my rollout\" height:16 align:#center offset:[-2,0])\n"+\
			"button ceate_btn \"create custom attributes >\" width:200 height:30 offset:[-2,0]\n"

		-- generate a random color for the tags...
		tagColor = random (color 0 0 0) (color 255 255 255)

		setPropGrp = ""; setUpS = ""; i = 1

		-- filters the template list builds the strings to setup the custom attributes...	
		for listItem in listArray do (

			iS = i as string
			tagColorS = tagColor as string

			-- builds the strings to setup the custom attributes...	
			if listItem == caSliderWithSpinner_source.attributeLabel do (
				
				setUpS += \
					"append ca1_colorArray tag_color" + iS + ".color\n"+\
					"append ca1_nameArray sld_name" + iS + ".text\n"+\
					"append ca1_minArray ui_spn_min" + iS + ".value\n"+\
					"append ca1_maxArray ui_spn_max" + iS + ".value\n"

				setPropGrp += caSliderWithSpinner_source.setUpUiPrp iS tagColorS
				tagColor = tagColor * 0.5
				)
			if listItem == caTransformSpinners_source.attributeLabel do (

				setUpS += \
					"append ca2_propArray rdo_trm" + iS + ".state\n"+\
					"append ca2_minArray ui_spnX_min" + iS + ".value\n"+\
					"append ca2_maxArray ui_spnX_max" + iS + ".value\n"+\
					"append ca2_minArray ui_spnY_min" + iS + ".value\n"+\
					"append ca2_maxArray ui_spnY_max" + iS + ".value\n"+\
					"append ca2_minArray ui_spnZ_min" + iS + ".value\n"+\
					"append ca2_maxArray ui_spnZ_max" + iS + ".value\n"

				setPropGrp += caTransformSpinners_source.setUpUiPrp iS
				)
			i+=1
			)

		eventGrp = \
			"on ddl_mod rightClick do (\n"+\
			"modArray = #()\n"+\
			"if selection.count == 1 do (\n"+\
			"for m in $.modifiers do append modArray m.name\n"+\
			"insertItem \"new attribute holder\" modArray 1)\nddl_mod.items = modArray)\n"+\
			"on ceate_btn pressed do (\n"+\
			"ca1_colorArray = #(); ca1_nameArray = # (); ca1_minArray = #(); ca1_maxArray = #()\n"+\
			"i = 1; ca2_minArray = #(); ca2_maxArray = #(); ca2_propArray = #()\n"+ setUpS +\
			"ca1_setUpArray = #(ca1_colorArray,ca1_nameArray,ca1_minArray,ca1_maxArray)\n"+\
			"ca2_setUpArray = #(ca2_minArray,ca2_maxArray,ca2_propArray)\n"+\
			"ctrlmkrCaSetUp_source.ca_build " + listArray as string + " roll_name.text ca1_setUpArray ca2_setUpArray\n"

		-- builds the strings to setup the custom attributes...
		infoGrp = \
		"group \" info: \" (\n"+\
		"label lab_credit1 \"set everything and click the big button\" align:#center)\n"

		rollEnd = "))createDialog setUpUi"

		-- concatenates all the strings...
		setUpUiS = rollStart + rollGrp + setPropGrp + infoGrp + eventGrp + rollEnd
		execute setUpUiS
		)
	)
ctrlmkrCaSetUp_source = ctrlmkrCaSetUp_source()

