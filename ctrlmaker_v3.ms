-- contains the label setup ui and attribute parameters/ui for the templates...
include "generic slider with spinner attributes.ms"
include "transform spinners attributes.ms"

-- try to closes any instance of the main ui rollout...
try (destroyDialog ctrlmakerMainUi) catch()

struct ctrlmkr_source (
	
	-- checks the attribute holder modifier...
	fn checkHolder obj holderName = (
		holder = EmptyModifier name:holderName

		if obj.modifiers[holderName] == undefined do addModifier $ holder
		),

	-- sets all the attribute template labels...
	fn setTemplateLabels = (
		item1 = gernericSliderWithSpinnerAttributes_source.attributeLabel
		item2 = transformSpinnersAttributes_source.attributeLabel

		templateLabels = #(item1,item2)

		return templateLabels
		),

	-- filters the template list and builds the custom attribute definition...
	fn ca_build listArray rollName ca1_setUpArray ca2_setUpArray = (

		-- starts the custom attribute definition...
		caStart = "ca = Attributes '" + rollName + "' (\nparameters '" + rollName + "' rollout:'" + rollName + "Ui' (\n"
		-- starts the rollout definition...
		caRollStart = ")\nrollout '" + rollName + "Ui' \"" + rollName + "\" (\n"

		caParams = ""; caUi = ""; i = 1; j = 1

		-- filters the template list to append the custom attribute parameters and ui...
		for listItem in listArray do (

			iS = i as string
			

			if listItem == gernericSliderWithSpinnerAttributes_source.attributeLabel do (
			
				-- first custom attribute settings...
				ca1_colorArray = ca1_setUpArray[1]
				ca1_nameArray = ca1_setUpArray[2]
				ca1_minArray = ca1_setUpArray[3]
				ca1_maxArray = ca1_setUpArray[4]

				setUpItem1 = gernericSliderWithSpinnerAttributes_source.caParamUi iS rollName ca1_colorArray[i] ca1_nameArray[i] ca1_minArray[i] ca1_maxArray[i]
				
				caParams += setUpItem1[1]
				caUi += setUpItem1[2]
				)
			if listItem == transformSpinnersAttributes_source.attributeLabel do (

				-- second custom attribute settings...
				ca2_minArray = #((ca2_setUpArray[1])[j],(ca2_setUpArray[1])[j+1],(ca2_setUpArray[1])[j+2])
				ca2_maxArray = #((ca2_setUpArray[2])[j],(ca2_setUpArray[2])[j+1],(ca2_setUpArray[2])[j+2])
				ca2_propArray = ca2_setUpArray[3]

				j+=3

				setUpItem2 = transformSpinnersAttributes_source.caParamUi iS rollName ca2_minArray ca2_maxArray ca2_propArray[i]
				caParams += setUpItem2[1]
				caUi += setUpItem2[2]
				)
			i+=1
			)

		-- ends the custom attribute definition and adds to the selected object first modifier...
		caEnd = ")\n)\ncustAttributes.add $.modifiers[1] ca\nfree ca"

		caS = caStart + caParams + caRollStart + caUi + caEnd
		execute caS
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
			if listItem == gernericSliderWithSpinnerAttributes_source.attributeLabel do (
				
				setUpS += \
					"append ca1_colorArray tag_color" + iS + ".color\n"+\
					"append ca1_nameArray sld_name" + iS + ".text\n"+\
					"append ca1_minArray ui_spn_min" + iS + ".value\n"+\
					"append ca1_maxArray ui_spn_max" + iS + ".value\n"

				setPropGrp += gernericSliderWithSpinnerAttributes_source.setUpUiPrp iS tagColorS
				tagColor = tagColor * 0.5
				)
			if listItem == transformSpinnersAttributes_source.attributeLabel do (

				setUpS += \
					"append ca2_propArray rdo_trm" + iS + ".state\n"+\
					"append ca2_minArray ui_spnX_min" + iS + ".value\n"+\
					"append ca2_maxArray ui_spnX_max" + iS + ".value\n"+\
					"append ca2_minArray ui_spnY_min" + iS + ".value\n"+\
					"append ca2_maxArray ui_spnY_max" + iS + ".value\n"+\
					"append ca2_minArray ui_spnZ_min" + iS + ".value\n"+\
					"append ca2_maxArray ui_spnZ_max" + iS + ".value\n"

				setPropGrp += transformSpinnersAttributes_source.setUpUiPrp iS
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
			"ctrlmkr_source.ca_build " + listArray as string + " roll_name.text ca1_setUpArray ca2_setUpArray\n"

		-- builds the strings to setup the custom attributes...
		infoGrp = \
		"group \" info: \" (\n"+\
		"label lab_credit1 \"set everything and click the big button\" align:#center)\n"

		rollEnd = "))createDialog setUpUi"

		-- concatenates all the strings...
		setUpUiS = rollStart + rollGrp + setPropGrp + infoGrp + eventGrp + rollEnd
		execute setUpUiS
		),

	-- moves selected items of a listbox by steps...
	fn moveListItems itemArray index step = (
		listArray = itemArray
		listIndex = index
		returnIndex = undefined
		newIndex = undefined

		-- restricts the first item to go up and the last to go down...
		if step >= 0 then (
			if listIndex > 1 then (
				returnIndex = listIndex - step
				newIndex = listIndex - step
				)
			else (
				returnIndex = listIndex
				newIndex = listIndex
				)
			)
		else (
			if listIndex < listArray.count then (
				returnIndex = listIndex - step
				newIndex = listIndex - step + 1
				)
			else (
				returnIndex = listIndex
				newIndex = listIndex
				)
			)

		-- changes the array...
		insertItem itemArray[index] listArray (newIndex)
		if step >= 0 then (
			deleteItem listArray (listIndex + step)
			)
		else (
			deleteItem listArray (listIndex - step - 1)
			)

		return #(listArray,returnIndex)
		),
-------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------
	-- creates the main ui rollout...
	fn mainUi_build = (
		rollout ctrlmakerMainUi "ctrlmaker" width:210 (
			group " select template: " (
				dropdownlist ddl_attributes "" width:130 items:(ctrlmkr_source.setTemplateLabels()) across:2
				button btn_add "add" width:50 align:#right
				)
			group " rollout components: " (
				listbox list_caTemplates "" items:#() height:15
				button btn_up "up" width:90 align:#left
				button btn_down "down" width:90 align:#left
				button btn_del "delete" width:90 height:48 align:#right offset:[0,-52]
				)
			button btn_set "set properties" width:200 height:48 align:#center
			group " abaut: " (
				label lab_credit1 "ctrlmaker v3" across:2 align:#left
				hyperLink link_credit "pointlesspineapple.com" address:"https://www.pointlesspineapple.com/" align:#right
				)

			-- adds the selected template to the components list...
			on btn_add pressed do (
				newListSetup = list_caTemplates.items
				newIndex = newListSetup.count + 1

				insertItem ddl_attributes.selected newListSetup newIndex
				list_caTemplates.items = newListSetup
				list_caTemplates.selection = newIndex
				)
			-- moves the selected template up in the components list...
			on btn_up pressed do (
				if list_caTemplates.items.count >= 2 do (
					newListSetup = ctrlmkr_source.moveListItems lisst_caTemplate.items list_caTemplate.selection 1
					list_caTemplates.items = newListSetup[1]
					list_caTemplates.selection = newListSetup[2]
					)
				)
			-- moves the selected template down in the components list...
			on btn_down pressed do (
				if list_caTemplates.items.count >= 2 do (
					newListSetup = ctrlmkr_source.moveListItems lisst_caTemplate.items list_caTemplate.selection -1
					list_caTemplates.items = newListSetup[1]
					list_caTemplates.selection = newListSetup[2]
					)
				)
			-- deletes the selected template in the components list...
			on btn_del pressed do (
				newListSetup = list_caTemplates.items
				listIndex = list_caTemplates.selection
				newIndex = listIndex - 1

				if listIndex >= 1 do (
					if list_caTemplates.selection == 1 do newIndex = 1
					deleteItem newListSetup listIndex
					if newListSetup.count == 1 do newIndex = 1
					)
				list_caTemplates.items = newListSetup
				list_caTemplates.selection = newIndex
				)
			-- creates the setup ui for every template in the components list...
			on btn_set pressed do (
				ctrlmkr_source.setUpUi_build list_caTemplates.items
				)
			)
		createDialog ctrlmakerMainUi
		)
	)

ctrlmkr_source = ctrlmkr_source()

ctrlmkr_source.mainUi_build()