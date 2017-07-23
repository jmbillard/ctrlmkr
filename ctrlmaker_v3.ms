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

	-- moves selected items of a listbox by steps...
	fn moveListItems itemArray index step = (
		listArray = itemArray
		listIndex = index
		returnIndex = undefined
		newIndex = undefined

		-- restricts the firt item to go up and the last to go down...
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

	-- main ui rollout...
	fn mainUi = (
		rollout ctrlmakerMainUi "ctrlmaker" width:210 (
			group " select template: " (
				dropdownlist ddl_attributes "" width:130 items:(ctrlmkr_source.setTemplateLabels()) across:2
				button btn_add "add" width:50 align:#right
				)
			group " components: " (
				listbox attList "" items:#() height:15
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
				newListSetup = attList.items
				newIndex = newListSetup.count + 1

				insertItem ddl_attributes.selected newListSetup newIndex
				attList.items = newListSetup
				attList.selection = newIndex
				)
			-- moves the selected template up in the components list...
			on btn_up pressed do (
				if attList.items.count >= 2 do (
					newListSetup = ctrlmkr_source.moveListItems attList.items attList.selection 1
					attList.items = newListSetup[1]
					attList.selection = newListSetup[2]
					)
				)
			-- moves the selected template down in the components list...
			on btn_down pressed do (
				if attList.items.count >= 2 do (
					newListSetup = ctrlmkr_source.moveListItems attList.items attList.selection -1
					attList.items = newListSetup[1]
					attList.selection = newListSetup[2]
					)
				)
			-- deletes the selected template in the components list...
			on btn_del pressed do (
				newListSetup = attList.items
				listIndex = attList.selection
				newIndex = listIndex - 1

				if listIndex >= 1 do (
					if attList.selection == 1 do newIndex = 1
					deleteItem newListSetup listIndex
					if newListSetup.count == 1 do newIndex = 1
					)
				attList.items = newListSetup
				attList.selection = newIndex
				)
			on btn_set pressed do (

				--xxx = gernericSliderWithSpinnerAttributes_source()
				--zzz = transformSpinnersAttributes_source()

				rollStart = "rollout setPropUi \"ui properties\" width:220\n(\n"
				
				rollGrp = \
					"group \" rollout name: \" (\n"+\
					"editText roll_name \"\" text:\"my rollout\" width:200 height:16 align:#right offset:[0,0]\n)\n"+\
					"button ceate_btn \"create custom attributes >\" width:198 height:30 offset:[-2,0]\n"

				tagcolor = random (color 0 0 0) (color 255 255 255)

				setPropGrp = ""
				i = 1
				for listItem in attList.items do (
					iS = i as string
					tagcolorS = tagcolor as string

					if listItem == gernericSliderWithSpinnerAttributes_source.attributeLabel do (
						append setPropGrp (gernericSliderWithSpinnerAttributes_source.setPropUi iS tagcolorS)
						tagcolor = tagcolor * 0.5
						)
					if listItem == transformSpinnersAttributes_source.attributeLabel do (
						append setPropGrp (\
							"group \" transform spinners: \" (\n"+\
							"label lab_Pos" + iS + " \"position:\" align:#left\n" +\
							"spinner ui_spnPosX_min" + iS + " \"\"  width:60 range:[-9999999,9999999,-999] type:#float align:#left offset:[-4,0]\n"+\
							"spinner ui_spnPosX_max" + iS + " \"\" width:60 range:[-9999999,9999999,999] type:#float align:#right offset:[0,-21]\n"+\
							"label labPosX_range" + iS + " \"< X ranges >\" align:#center offset:[0,-21]\n"+\
							"spinner ui_spnPosY_min" + iS + " \"\"  width:60 range:[-9999999,9999999,-999] type:#float align:#left offset:[-4,0]\n"+\
							"spinner ui_spnPosY_max" + iS + " \"\" width:60 range:[-9999999,9999999,999] type:#float align:#right offset:[0,-21]\n"+\
							"label labPosY_range" + iS + " \"< Y ranges >\" align:#center offset:[0,-21]\n"+\
							"spinner ui_spnPosZ_min" + iS + " \"\"  width:60 range:[-9999999,9999999,-999] type:#float align:#left offset:[-4,0]\n"+\
							"spinner ui_spnPosZ_max" + iS + " \"\" width:60 range:[-9999999,9999999,999] type:#float align:#right offset:[0,-21]\n"+\
							"label labPosZ_range" + iS + " \"< Z ranges >\" align:#center offset:[0,-21]\n)\n"
							)
						)

					i+=1
					)
				rollEnd = \
				"group \" info: \" (\n"+\
				"label lab_credit1 \"set everything and click the big button\" align:#center\n"+\
				")\n)createDialog setPropUi"

				setPropUi = rollStart + rollGrp + setPropGrp + rollEnd

				execute setPropUi
				)
			)
		createDialog ctrlmakerMainUi
		)
	)

ctrlmkr_source = ctrlmkr_source()

ctrlmkr_source.mainUi()
-- adds the selected template to the components list...
