/*
//  This code is adapted from the work of:
//  Created by Michael Nachbaur on 13/04/09.
//  Copyright 2009 Decaf Ninja Software. All rights reserved.
//  MIT licensed
*/

/**
 * This class exposes mobile phone interface controls to JavaScript, such as
 * native tab and nav bars, etc.
 * @constructor
 */
function NativeControls() {
    this.tabBarTag = 0;
    this.tabBarCallbacks = {};
    this.selectedTabBarItem = null;
}

/**
 * Create a native tab bar that can have tab buttons added to it which can respond to events.
 * USAGE:
 * window.plugins.nativeControls.createTabBar(); // default iOS BG (Black with gloss)
 * window.plugins.nativeControls.createTabBar({ bgImage: 'www/img/tabBarImage.png' }); //points to some image at www folder
 */
NativeControls.prototype.createTabBar = function(options) {
    if (!options) options = {'bgImage' : ''};
	if (options && 'bgImage' in options && typeof(options['bgImage']) == 'string' && options['bgImage'] != '') {
	    PhoneGap.exec("NativeControls.createTabBar", options.bgImage);
    }else{
   	    PhoneGap.exec("NativeControls.createTabBar", '');
    }
};

/**
 * Show a tab bar.  The tab bar has to be created first.
 * @param {Object} [options] Options indicating how the tab bar should be shown:
 * - \c height integer indicating the height of the tab bar (default: \c 49)
 * - \c position specifies whether the tab bar will be placed at the \c top or \c bottom of the screen (default: \c bottom)
 */
NativeControls.prototype.showTabBar = function(options) {
    if (!options) options = {'position' : 'bottom'};
    PhoneGap.exec("NativeControls.showTabBar", options);
};

/**
 * Hide a tab bar.  The tab bar has to be created first.
 */
NativeControls.prototype.hideTabBar = function(animate) {
    if (animate == undefined || animate == null)
        animate = true;
    PhoneGap.exec("NativeControls.hideTabBar", { animate: animate });
};


/**
 * Create a new tab bar item for use on a previously created tab bar.  Use ::showTabBarItems to show the new item on the tab bar.
 *
 * If the supplied image name is one of the labels listed below, then this method will construct a tab button
 * using the standard system buttons.  Note that if you use one of the system images, that the \c title you supply will be ignored.
 *
 * <b>Tab Buttons</b>
 *   - tabButton:More
 *   - tabButton:Favorites
 *   - tabButton:Featured
 *   - tabButton:TopRated
 *   - tabButton:Recents
 *   - tabButton:Contacts
 *   - tabButton:History
 *   - tabButton:Bookmarks
 *   - tabButton:Search
 *   - tabButton:Downloads
 *   - tabButton:MostRecent
 *   - tabButton:MostViewed
 * @param {String} name internal name to refer to this tab by
 * @param {String} [title] title text to show on the tab, or null if no text should be shown
 * @param {String} [image] image filename or internal identifier to show, or null if now image should be shown
 * @param {Object} [options] Options for customizing the individual tab item
 *  - \c badge value to display in the optional circular badge on the item; if null or unspecified, the badge will be hidden
 */
NativeControls.prototype.createTabBarItem = function(name, label, image, options) {
    
	var tag = this.tabBarTag++;
    if (options && 'onSelect' in options && typeof(options['onSelect']) == 'function') {
        this.tabBarCallbacks[tag] = {'onSelect':options.onSelect,'name':name};
        //delete options.onSelect;
    }
	
    PhoneGap.exec("NativeControls.createTabBarItem", name, label, image, tag, options);
};

/**
 * Update an existing tab bar item to change its badge value.
 * @param {String} name internal name used to represent this item when it was created
 * @param {Object} options Options for customizing the individual tab item
 *  - \c badge value to display in the optional circular badge on the item; if null or unspecified, the badge will be hidden
 */
NativeControls.prototype.updateTabBarItem = function(name, options) {
    if (!options) options = {};
    PhoneGap.exec("NativeControls.updateTabBarItem", name, options);
};

/**
 * Show previously created items on the tab bar
 * @param {String} arguments... the item names to be shown
 * @param {Object} [options] dictionary of options, notable options including:
 *  - \c animate indicates that the items should animate onto the tab bar
 * @see createTabBarItem
 * @see createTabBar
 */
NativeControls.prototype.showTabBarItems = function() {
    var parameters = [ "NativeControls.showTabBarItems" ];
    for (var i = 0; i < arguments.length; i++) {
        parameters.push(arguments[i]);
    }
    PhoneGap.exec.apply(this, parameters);
};


/**
 * Function to detect currently selected tab bar item
 * @see createTabBarItem
 * @see showTabBarItems
 */
NativeControls.prototype.getSelectedTabBarItem = function() {
    return this.selectedTabBarItem;
};


/**
 * Manually select an individual tab bar item, or nil for deselecting a currently selected tab bar item.
 * @param {String} tabName the name of the tab to select, or null if all tabs should be deselected
 * @see createTabBarItem
 * @see showTabBarItems
 */
NativeControls.prototype.selectTabBarItem = function(tab) {
    PhoneGap.exec("NativeControls.selectTabBarItem", tab);
};

/**
 * Function called when a tab bar item has been selected.
 * @param {Number} tag the tag number for the item that has been selected
 */
NativeControls.prototype.tabBarItemSelected = function(tag) 
{
	this.selectedTabBarItem = tag;
    if (typeof(this.tabBarCallbacks[tag].onSelect) == 'function')
        this.tabBarCallbacks[tag].onSelect(this.tabBarCallbacks[tag].name);
};

/**
 * Create a NavBar.
 */
NativeControls.prototype.createNavBar = function() 
{
    PhoneGap.exec("NativeControls.createNavBar");
};

/**
 * Create a NavBar.
 */
NativeControls.prototype.setupLeftNavButton = function(title, imageURL, onselect) 
{
    PhoneGap.exec("NativeControls.setupLeftNavButton", title, imageURL, onselect);
};

NativeControls.prototype.hideLeftNavButton = function() 
{
    PhoneGap.exec("NativeControls.hideLeftNavButton");
};

NativeControls.prototype.showLeftNavButton = function() 
{
    PhoneGap.exec("NativeControls.showLeftNavButton");
};

/**
 * Create a NavBar.
 */
NativeControls.prototype.setupRightNavButton = function(title, imageURL, onselect) 
{
    PhoneGap.exec("NativeControls.setupRightNavButton", title, imageURL, onselect);
};


NativeControls.prototype.hideRightNavButton = function() 
{
    PhoneGap.exec("NativeControls.hideRightNavButton");
};

NativeControls.prototype.showRightNavButton = function() 
{
    PhoneGap.exec("NativeControls.showRightNavButton");
};

/**
 * Function called to set the title of the navBar
 * @param {String} title the title to set within the NavBar
 */
NativeControls.prototype.setNavBarTitle = function(title) 
{
    PhoneGap.exec("NativeControls.setNavBarTitle", title);
};

/**
 * Function called to set the title of the navBar
 * @param {String} imageURL full URL to the image 
 */
NativeControls.prototype.setNavBarLogo = function(imageURL) 
{
    PhoneGap.exec("NativeControls.setNavBarLogo", imageURL);
};

/**
 * Show a nav bar.  The nav bar has to be created first.
 * @param none 
 */
NativeControls.prototype.showNavBar = function() {
    PhoneGap.exec("NativeControls.showNavBar");
};

/**
 * Hide a nav bar.  The nav bar has to be created first.
 */
NativeControls.prototype.hideNavBar = function() {
   
    PhoneGap.exec("NativeControls.hideNavBar");
};


NativeControls.prototype.createActionSheet = function(buttonTitles,actionSheetTitle,cancelButtonIndex,destructiveButtonIndex)
{
	var options = {};
	
	if(actionSheetTitle != null)
	{
		options.title = actionSheetTitle;
	}
	if(cancelButtonIndex != null)
	{
		options.cancelButtonIndex = cancelButtonIndex;
	}
	if(destructiveButtonIndex != null)
	{
		options.destructiveButtonIndex = destructiveButtonIndex;
	}

	var params = [ "NativeControls.createActionSheet",options ];
    for (var i = 0; i < buttonTitles.length; i++) 
	{
        params.push(buttonTitles[i]);
    }
    PhoneGap.exec.apply(this, params);
	
	this.actionSheetDelegate = {};
	return this.actionSheetDelegate;
}

NativeControls.prototype._onActionSheetDismissed = function(index)
{
	this.actionSheetDelegate.onActionSheetDismissed(index);
}

PhoneGap.addConstructor(function() 
{
	if(!window.plugins)
	{
		window.plugins = {};
	}
    window.plugins.nativeControls = new NativeControls();
});

function StatusBar()
{
	
}

StatusBar.prototype.setHidden = function(bHide)
{
	PhoneGap.exec("StatusBar.setHidden",bHide);
}

PhoneGap.addConstructor(
						
						function() 
						{
						if (typeof window.plugins == "undefined") 
						window.plugins = {};
						
						if (typeof window.plugins.statusBar == "undefined")
						window.plugins.statusBar = new StatusBar();
						
						}
						);
