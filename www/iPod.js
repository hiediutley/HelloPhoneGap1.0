function iPod()
{

};

iPod.prototype.selectSong = function(successCallback, failureCallback)
{
PhoneGap.exec('iPodCommand.selectSong', successCallback, failureCallback);

};

iPod.prototype.playSong = function()
{
PhoneGap.exec('iPodCommand.playSong');


};

iPod.install = function()
{
if(!window.plugins)
{
window.plugins = {};	
}

window.plugins.iPod = new iPod();
return window.plugins.iPod;
};

PhoneGap.addConstructor(iPod.install);

