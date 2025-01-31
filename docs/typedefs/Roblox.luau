type InstanceProperties = {
	Parent: Instance?,
	ClassName: string,
	Name: string,
	-- FIXME: This breaks intellisense, but we need some way to access
	-- instance properties without casting the entire instance to any...
	-- [string]: any,
}

type InstanceMetatable = {
	Clone: (self: Instance) -> Instance,
	Destroy: (self: Instance) -> (),
	ClearAllChildren: (self: Instance) -> (),

	GetChildren: (self: Instance) -> { Instance },
	GetDescendants: (self: Instance) -> { Instance },
	GetFullName: (self: Instance) -> string,

	FindFirstAncestor: (self: Instance, name: string) -> Instance?,
	FindFirstAncestorOfClass: (self: Instance, className: string) -> Instance?,
	FindFirstAncestorWhichIsA: (self: Instance, className: string) -> Instance?,
	FindFirstChild: (self: Instance, name: string, recursive: boolean?) -> Instance?,
	FindFirstChildOfClass: (self: Instance, className: string, recursive: boolean?) -> Instance?,
	FindFirstChildWhichIsA: (self: Instance, className: string, recursive: boolean?) -> Instance?,

	IsA: (self: Instance, className: string) -> boolean,
	IsAncestorOf: (self: Instance, descendant: Instance) -> boolean,
	IsDescendantOf: (self: Instance, ancestor: Instance) -> boolean,

	GetAttribute: (self: Instance, name: string) -> any,
	GetAttributes: (self: Instance) -> { [string]: any },
	SetAttribute: (self: Instance, name: string, value: any) -> (),

	GetTags: (self: Instance) -> { string },
	HasTag: (self: Instance, name: string) -> boolean,
	AddTag: (self: Instance, name: string) -> (),
	RemoveTag: (self: Instance, name: string) -> (),
}

export type Instance = typeof(setmetatable(
	(nil :: any) :: InstanceProperties,
	(nil :: any) :: { __index: InstanceMetatable }
))

export type DataModelProperties = {}
export type DataModelMetatable = {
	GetService: (self: DataModel, name: string) -> Instance,
	FindService: (self: DataModel, name: string) -> Instance?,
}

export type DataModel =
	Instance
	& typeof(setmetatable(
		(nil :: any) :: DataModelProperties,
		(nil :: any) :: { __index: DataModelMetatable }
	))

--[=[
	@class Roblox

	Built-in library for manipulating Roblox place & model files

	### Example usage

	```lua
	local fs = require("@lune/fs")
	local roblox = require("@lune/roblox")

	-- Reading a place file
	local placeFile = fs.readFile("myPlaceFile.rbxl")
	local game = roblox.deserializePlace(placeFile)

	-- Manipulating and reading instances - just like in Roblox!
	local workspace = game:GetService("Workspace")
	for _, child in workspace:GetChildren() do
		print("Found child " .. child.Name .. " of class " .. child.ClassName)
	end

	-- Writing a place file
	local newPlaceFile = roblox.serializePlace(game)
	fs.writeFile("myPlaceFile.rbxl", newPlaceFile)
	```
]=]
return {
	--[=[
		@within Roblox
		@must_use

		Deserializes a place into a DataModel instance.

		This function accepts a string of contents, *not* a file path.
		If reading a place file from a file path is desired, `fs.readFile`
		can be used and the resulting string may be passed to this function.

		### Example usage

		```lua
		local fs = require("@lune/fs")
		local roblox = require("@lune/roblox")

		local placeFile = fs.readFile("filePath.rbxl")
		local game = roblox.deserializePlace(placeFile)
		```

		@param contents The contents of the place to read
	]=]
	deserializePlace = function(contents: string): DataModel
		return nil :: any
	end,
	--[=[
		@within Roblox
		@must_use

		Deserializes a model into an array of instances.

		This function accepts a string of contents, *not* a file path.
		If reading a model file from a file path is desired, `fs.readFile`
		can be used and the resulting string may be passed to this function.

		### Example usage

		```lua
		local fs = require("@lune/fs")
		local roblox = require("@lune/roblox")

		local modelFile = fs.readFile("filePath.rbxm")
		local instances = roblox.deserializeModel(modelFile)
		```

		@param contents The contents of the model to read
	]=]
	deserializeModel = function(contents: string): { Instance }
		return nil :: any
	end,
	--[=[
		@within Roblox
		@must_use

		Serializes a place from a DataModel instance.

		This string can then be written to a file, or sent over the network.

		### Example usage

		```lua
		local fs = require("@lune/fs")
		local roblox = require("@lune/roblox")

		local placeFile = roblox.serializePlace(game)
		fs.writeFile("filePath.rbxl", placeFile)
		```

		@param dataModel The DataModel for the place to serialize
		@param xml If the place should be serialized as xml or not. Defaults to `false`, meaning the place gets serialized using the binary format and not xml.
	]=]
	serializePlace = function(dataModel: DataModel, xml: boolean?): string
		return nil :: any
	end,
	--[=[
		@within Roblox
		@must_use

		Serializes one or more instances as a model.

		This string can then be written to a file, or sent over the network.

		### Example usage

		```lua
		local fs = require("@lune/fs")
		local roblox = require("@lune/roblox")

		local modelFile = roblox.serializeModel({ instance1, instance2, ... })
		fs.writeFile("filePath.rbxm", modelFile)
		```

		@param instances The array of instances to serialize
		@param xml If the model should be serialized as xml or not. Defaults to `false`, meaning the model gets serialized using the binary format and not xml.
	]=]
	serializeModel = function(instances: { Instance }, xml: boolean?): string
		return nil :: any
	end,
	--[=[
		@within Roblox
		@must_use

		Gets the current auth cookie, for usage with Roblox web APIs.

		Note that this auth cookie is formatted for use as a "Cookie" header,
		and that it contains restrictions so that it may only be used for
		official Roblox endpoints. To get the raw cookie value without any
		additional formatting, you can pass `true` as the first and only parameter.

		### Example usage

		```lua
		local roblox = require("@lune/roblox")
		local net = require("@lune/net")

		local cookie = roblox.getAuthCookie()
		assert(cookie ~= nil, "Failed to get roblox auth cookie")

		local myPrivatePlaceId = 1234567890

		local response = net.request({
			url = "https://assetdelivery.roblox.com/v2/assetId/" .. tostring(myPrivatePlaceId),
			headers = {
				Cookie = cookie,
			},
		})

		local responseTable = net.jsonDecode(response.body)
		local responseLocation = responseTable.locations[1].location
		print("Download link to place: " .. responseLocation)
		```

		@param raw If the cookie should be returned as a pure value or not. Defaults to false
	]=]
	getAuthCookie = function(raw: boolean?): string?
		return nil :: any
	end,
	-- TODO: Make typedefs for all of the datatypes as well...
	Instance = (nil :: any) :: {
		new: ((className: "DataModel") -> DataModel) & ((className: string) -> Instance),
	},
}
