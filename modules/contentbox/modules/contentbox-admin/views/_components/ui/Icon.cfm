<cfoutput>
    <!--- Icon name --->
    <cfparam name="args.name" 	 default="info">
    <!--- Icon Size --->
    <cfparam name="args.size"    default="md">
    <!--- Icon Class --->
    <cfparam name="args.class"   default="">

    <icon class="cbicon cbicon-#args.size# #args.class#">
        <svg fill="none" stroke="currentColor" stroke-width="1.75" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">      
            <cfswitch expression=#args.name#>
                <cfcase value="ArchiveBox">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M20.25 7.5l-.625 10.632a2.25 2.25 0 01-2.247 2.118H6.622a2.25 2.25 0 01-2.247-2.118L3.75 7.5M10 11.25h4M3.375 7.5h17.25c.621 0 1.125-.504 1.125-1.125v-1.5c0-.621-.504-1.125-1.125-1.125H3.375c-.621 0-1.125.504-1.125 1.125v1.5c0 .621.504 1.125 1.125 1.125z"></path>
                </cfcase>
                <cfcase value="ArrowDownTray">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M3 16.5v2.25A2.25 2.25 0 005.25 21h13.5A2.25 2.25 0 0021 18.75V16.5M16.5 12L12 16.5m0 0L7.5 12m4.5 4.5V3"></path>
                </cfcase>
                <cfcase value="ArrowLeftCircle">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M11.25 9l-3 3m0 0l3 3m-3-3h7.5M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                </cfcase>
                <cfcase value="ArrowLeftOnRectangle">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 9V5.25A2.25 2.25 0 0013.5 3h-6a2.25 2.25 0 00-2.25 2.25v13.5A2.25 2.25 0 007.5 21h6a2.25 2.25 0 002.25-2.25V15M12 9l-3 3m0 0l3 3m-3-3h12.75"></path>
                </cfcase>
                <cfcase value="ArrowPath">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M16.023 9.348h4.992v-.001M2.985 19.644v-4.992m0 0h4.992m-4.993 0l3.181 3.183a8.25 8.25 0 0013.803-3.7M4.031 9.865a8.25 8.25 0 0113.803-3.7l3.181 3.182m0-4.991v4.99"></path>
                </cfcase>
                <cfcase value="ArrowRightOnRectangle">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 9V5.25A2.25 2.25 0 0013.5 3h-6a2.25 2.25 0 00-2.25 2.25v13.5A2.25 2.25 0 007.5 21h6a2.25 2.25 0 002.25-2.25V15m3 0l3-3m0 0l-3-3m3 3H9"></path>
                </cfcase>
                <cfcase value="ArrowUpTray">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M3 16.5v2.25A2.25 2.25 0 005.25 21h13.5A2.25 2.25 0 0021 18.75V16.5m-13.5-9L12 3m0 0l4.5 4.5M12 3v13.5"></path>
                </cfcase>
                <cfcase value="ArrowUturnLeft">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M9 15L3 9m0 0l6-6M3 9h12a6 6 0 010 12h-3"></path>
                </cfcase>
                <cfcase value="Bars3">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M3.75 6.75h16.5M3.75 12h16.5m-16.5 5.25h16.5"></path>
                </cfcase>
                <cfcase value="ChatBubbleBottomCenterText">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M7.5 8.25h9m-9 3H12m-9.75 1.51c0 1.6 1.123 2.994 2.707 3.227 1.129.166 2.27.293 3.423.379.35.026.67.21.865.501L12 21l2.755-4.133a1.14 1.14 0 01.865-.501 48.172 48.172 0 003.423-.379c1.584-.233 2.707-1.626 2.707-3.228V6.741c0-1.602-1.123-2.995-2.707-3.228A48.394 48.394 0 0012 3c-2.392 0-4.744.175-7.043.513C3.373 3.746 2.25 5.14 2.25 6.741v6.018z"></path>
                </cfcase>
                <cfcase value="ChevronDoubleRight">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M11.25 4.5l7.5 7.5-7.5 7.5m-6-15l7.5 7.5-7.5 7.5"></path>
                </cfcase>
                <cfcase value="ChevronDoubleDown">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M19.5 5.25l-7.5 7.5-7.5-7.5m15 6l-7.5 7.5-7.5-7.5"></path>
                </cfcase>
                <cfcase value="ChevronDown">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M19.5 8.25l-7.5 7.5-7.5-7.5"></path>
                </cfcase>
                <cfcase value="ChevronLeft">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 19.5L8.25 12l7.5-7.5"></path>
                </cfcase>
                <cfcase value="ChevronUpDown">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M8.25 15L12 18.75 15.75 15m-7.5-6L12 5.25 15.75 9"></path>
                </cfcase>
                <cfcase value="ClockArrowPath">
                    <polyline stroke-linecap="round" stroke-linejoin="round" points="17.47 11.2 10.8 11.2 10.8 16.2"/>
                    <path stroke-linecap="round" stroke-linejoin="round" d="m10.8,21.2c-5.52,0-10-4.48-10-10,0-5.52,4.48-10,10-10,3.37,0,6.36,1.67,8.17,4.23l-4.94.08m6.77,5.69M17.87.73l1.1,4.7"/>
                    <path stroke-linecap="round" stroke-linejoin="round" d="m20.66,13.46c-.26,1.1-.7,2.17-1.33,3.16m-2.58,2.75c-.74.54-1.55.98-2.38,1.3"/>
                </cfcase>
                <cfcase value="ClockWarning">
                    <path stroke-linecap="round" stroke-linejoin="round" d="m15.75,15.14v2.18m-5.31,1.96c-.49.87.12,1.96,1.11,1.96h8.4c.99,0,1.61-1.09,1.11-1.96l-4.2-7.41c-.49-.87-1.73-.87-2.23,0,0,0-4.2,7.41-4.2,7.41m5.31-.22h0s0,0,0,0h0Z"/>
                    <path stroke-linecap="round" stroke-linejoin="round" d="m6.5,11h4.5s0-6,0-6m-1.59,14.86c-4.21-.75-7.41-4.43-7.41-8.86,0-4.97,4.03-9,9-9s9,4.03,9,9c0,1.55-.39,3.01-1.09,4.29m-8.65,4.68c-.29-.02-.57-.06-.86-.11m9.5-4.57"/>
                </cfcase>
                <cfcase value="ClockDashedHalf">
                    <path stroke-linecap="round" stroke-linejoin="round" d="m11.06.73c5.64,0,10.21,4.57,10.21,10.21s-4.57,10.21-10.21,10.21M11.06.73c5.64,0,10.21,4.57,10.21,10.21M.85,10.94"/>
                    <polyline stroke-linecap="round" stroke-linejoin="round" points="11.06 4.13 11.06 10.94 16.16 10.94"/>
                    <path stroke-linecap="round" stroke-linejoin="round" d="m3.83,3.73c.78-.78,1.69-1.44,2.7-1.94M.96,9.41c.17-1.16.54-2.26,1.08-3.26m0,9.58c-.42-.79-.74-1.65-.94-2.54m5.43,6.91c-.94-.47-1.79-1.07-2.54-1.79"/>
                </cfcase>
                <cfcase value="Document">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M19.5 14.25v-2.625a3.375 3.375 0 00-3.375-3.375h-1.5A1.125 1.125 0 0113.5 7.125v-1.5a3.375 3.375 0 00-3.375-3.375H8.25m2.25 0H5.625c-.621 0-1.125.504-1.125 1.125v17.25c0 .621.504 1.125 1.125 1.125h12.75c.621 0 1.125-.504 1.125-1.125V11.25a9 9 0 00-9-9z"></path>
                </cfcase>
                <cfcase value="DocumentPlus">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M19.5 14.25v-2.625a3.375 3.375 0 00-3.375-3.375h-1.5A1.125 1.125 0 0113.5 7.125v-1.5a3.375 3.375 0 00-3.375-3.375H8.25m3.75 9v6m3-3H9m1.5-12H5.625c-.621 0-1.125.504-1.125 1.125v17.25c0 .621.504 1.125 1.125 1.125h12.75c.621 0 1.125-.504 1.125-1.125V11.25a9 9 0 00-9-9z"></path>
                </cfcase>
                <cfcase value="EllipsisHorizontalCircle">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M8.625 12a.375.375 0 11-.75 0 .375.375 0 01.75 0zm0 0H8.25m4.125 0a.375.375 0 11-.75 0 .375.375 0 01.75 0zm0 0H12m4.125 0a.375.375 0 11-.75 0 .375.375 0 01.75 0zm0 0h-.375M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                </cfcase>
                <cfcase value="EllipsisVertical">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M12 6.75a.75.75 0 110-1.5.75.75 0 010 1.5zM12 12.75a.75.75 0 110-1.5.75.75 0 010 1.5zM12 18.75a.75.75 0 110-1.5.75.75 0 010 1.5z"></path>
                </cfcase>
                <cfcase value="Eye">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M2.036 12.322a1.012 1.012 0 010-.639C3.423 7.51 7.36 4.5 12 4.5c4.638 0 8.573 3.007 9.963 7.178.07.207.07.431 0 .639C20.577 16.49 16.64 19.5 12 19.5c-4.638 0-8.573-3.007-9.963-7.178z"></path>
                    <path stroke-linecap="round" stroke-linejoin="round" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path>
                </cfcase>
                <cfcase value="Folder">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M2.25 12.75V12A2.25 2.25 0 014.5 9.75h15A2.25 2.25 0 0121.75 12v.75m-8.69-6.44l-2.12-2.12a1.5 1.5 0 00-1.061-.44H4.5A2.25 2.25 0 002.25 6v12a2.25 2.25 0 002.25 2.25h15A2.25 2.25 0 0021.75 18V9a2.25 2.25 0 00-2.25-2.25h-5.379a1.5 1.5 0 01-1.06-.44z"></path>
                </cfcase>
                <cfcase value="FolderList">
                    <path stroke-linecap="round" stroke-linejoin="round" d="m.88,10.69v-.82c0-1.36,1.14-2.45,2.54-2.45h16.92c1.4,0,2.54,1.1,2.54,2.45v.82M13.07,3.67l-2.39-2.31c-.32-.31-.75-.48-1.2-.48H3.41C2.01.88.88,1.97.88,3.33v13.09c0,1.36,1.14,2.45,2.54,2.45h16.92c1.4,0,2.54-1.1,2.54-2.45V6.6c0-1.36-1.14-2.45-2.54-2.45h-6.07c-.45,0-.88-.17-1.2-.48h0Z"/>
                    <line stroke-linecap="round" stroke-linejoin="round" x1="7.76" y1="10.75" x2="18.52" y2="10.75"/>
                    <line stroke-linecap="round" stroke-linejoin="round" x1="7.68" y1="14.86" x2="18.44" y2="14.86"/>
                    <line stroke-linecap="round" stroke-linejoin="round" x1="4.26" y1="10.75" x2="4.33" y2="10.75"/>
                    <line stroke-linecap="round" stroke-linejoin="round" x1="4.26" y1="14.86" x2="4.33" y2="14.86"/>
                </cfcase>
                <cfcase value="FolderPlus">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M12 10.5v6m3-3H9m4.06-7.19l-2.12-2.12a1.5 1.5 0 00-1.061-.44H4.5A2.25 2.25 0 002.25 6v12a2.25 2.25 0 002.25 2.25h15A2.25 2.25 0 0021.75 18V9a2.25 2.25 0 00-2.25-2.25h-5.379a1.5 1.5 0 01-1.06-.44z"></path>
                </cfcase>
                <cfcase value="Home">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M2.25 12l8.954-8.955c.44-.439 1.152-.439 1.591 0L21.75 12M4.5 9.75v10.125c0 .621.504 1.125 1.125 1.125H9.75v-4.875c0-.621.504-1.125 1.125-1.125h2.25c.621 0 1.125.504 1.125 1.125V21h4.125c.621 0 1.125-.504 1.125-1.125V9.75M8.25 21h8.25"></path>
                </cfcase>
                <cfcase value="ListBullet">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M8.25 6.75h12M8.25 12h12m-12 5.25h12M3.75 6.75h.007v.008H3.75V6.75zm.375 0a.375.375 0 11-.75 0 .375.375 0 01.75 0zM3.75 12h.007v.008H3.75V12zm.375 0a.375.375 0 11-.75 0 .375.375 0 01.75 0zm-.375 5.25h.007v.008H3.75v-.008zm.375 0a.375.375 0 11-.75 0 .375.375 0 01.75 0z"></path>
                </cfcase>
                <cfcase value="LockClosed">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M16.5 10.5V6.75a4.5 4.5 0 10-9 0v3.75m-.75 11.25h10.5a2.25 2.25 0 002.25-2.25v-6.75a2.25 2.25 0 00-2.25-2.25H6.75a2.25 2.25 0 00-2.25 2.25v6.75a2.25 2.25 0 002.25 2.25z"></path>
                </cfcase>
                <cfcase value="PencilSquare">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M16.862 4.487l1.687-1.688a1.875 1.875 0 112.652 2.652L10.582 16.07a4.5 4.5 0 01-1.897 1.13L6 18l.8-2.685a4.5 4.5 0 011.13-1.897l8.932-8.931zm0 0L19.5 7.125M18 14v4.75A2.25 2.25 0 0115.75 21H5.25A2.25 2.25 0 013 18.75V8.25A2.25 2.25 0 015.25 6H10"></path>
                </cfcase>
                <cfcase value="Photo">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M2.25 15.75l5.159-5.159a2.25 2.25 0 013.182 0l5.159 5.159m-1.5-1.5l1.409-1.409a2.25 2.25 0 013.182 0l2.909 2.909m-18 3.75h16.5a1.5 1.5 0 001.5-1.5V6a1.5 1.5 0 00-1.5-1.5H3.75A1.5 1.5 0 002.25 6v12a1.5 1.5 0 001.5 1.5zm10.5-11.25h.008v.008h-.008V8.25zm.375 0a.375.375 0 11-.75 0 .375.375 0 01.75 0z"></path>
                </cfcase>
                <cfcase value="PlusSmall">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M12 6v12m6-6H6"></path>
                </cfcase>
                <cfcase value="Rename">
                    <line stroke-linecap="round" stroke-linejoin="round" x1="11.27" y1=".88" x2="18.47" y2=".88"/>
                    <path stroke-linecap="round" stroke-linejoin="round" d="m10.94,16.06H3.03c-1.19,0-2.15-1.14-2.15-2.55v-5.41c0-1.41.96-2.55,2.15-2.55h7.92"/>
                    <path stroke-linecap="round" stroke-linejoin="round" d="m18.74,5.54h1.6c1.4,0,2.54,1.14,2.54,2.55v5.41c0,1.41-1.14,2.55-2.54,2.55h-1.6"/>
                    <line stroke-linecap="round" stroke-linejoin="round" x1="11.27" y1="19.27" x2="18.47" y2="19.27"/>
                    <line stroke-linecap="round" stroke-linejoin="round" x1="14.87" y1="18.27" x2="14.87" y2=".88"/>
                </cfcase>
                <cfcase value="SignalCircle">
                    <path stroke-linecap="round" stroke-linejoin="round" d="m8.63,9.9c1.94.05,3.4,1.66,3.25,3.6m-3.03-6.6c3.6.09,6.31,3.08,6.04,6.68M9.08,3.89c5.27.14,9.22,4.51,8.83,9.76"/>
                    <path stroke-linecap="round" stroke-linejoin="round" d="m20.85,10.97c0,5.52-4.48,10-10,10S.85,16.49.85,10.97,5.32.97,10.85.97s10,4.48,10,10Zm-13.39,2.51c-.7,0-1.27.57-1.27,1.27s.57,1.27,1.27,1.27,1.27-.57,1.27-1.27-.57-1.27-1.27-1.27Zm-2.53,4.19l1.84-1.84"/>
                </cfcase>
                <cfcase value="Server">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M21.75 17.25v-.228a4.5 4.5 0 00-.12-1.03l-2.268-9.64a3.375 3.375 0 00-3.285-2.602H7.923a3.375 3.375 0 00-3.285 2.602l-2.268 9.64a4.5 4.5 0 00-.12 1.03v.228m19.5 0a3 3 0 01-3 3H5.25a3 3 0 01-3-3m19.5 0a3 3 0 00-3-3H5.25a3 3 0 00-3 3m16.5 0h.008v.008h-.008v-.008zm-3 0h.008v.008h-.008v-.008z"></path>
                </cfcase>
                <cfcase value="SiteMap">
                    <path stroke-linecap="round" stroke-linejoin="round" d="m13.46,6.69h-5V1.69h5v5Zm.04,8.62h-5v5h5v-5Zm-7.5,0H1v5h5v-5Zm15,0h-5v5h5v-5ZM10.96,6.89v8.09m7.68,0v-4.48H3.46v4.48"/>
                </cfcase>
                <cfcase value="Squares2x2">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M3.75 6A2.25 2.25 0 016 3.75h2.25A2.25 2.25 0 0110.5 6v2.25a2.25 2.25 0 01-2.25 2.25H6a2.25 2.25 0 01-2.25-2.25V6zM3.75 15.75A2.25 2.25 0 016 13.5h2.25a2.25 2.25 0 012.25 2.25V18a2.25 2.25 0 01-2.25 2.25H6A2.25 2.25 0 013.75 18v-2.25zM13.5 6a2.25 2.25 0 012.25-2.25H18A2.25 2.25 0 0120.25 6v2.25A2.25 2.25 0 0118 10.5h-2.25a2.25 2.25 0 01-2.25-2.25V6zM13.5 15.75a2.25 2.25 0 012.25-2.25H18a2.25 2.25 0 012.25 2.25V18A2.25 2.25 0 0118 20.25h-2.25A2.25 2.25 0 0113.5 18v-2.25z"></path>
                </cfcase>
                <cfcase value="Tools">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M11.42 15.17L17.25 21A2.652 2.652 0 0021 17.25l-5.877-5.877M11.42 15.17l2.496-3.03c.317-.384.74-.626 1.208-.766M11.42 15.17l-4.655 5.653a2.548 2.548 0 11-3.586-3.586l6.837-5.63m5.108-.233c.55-.164 1.163-.188 1.743-.14a4.5 4.5 0 004.486-6.336l-3.276 3.277a3.004 3.004 0 01-2.25-2.25l3.276-3.276a4.5 4.5 0 00-6.336 4.486c.091 1.076-.071 2.264-.904 2.95l-.102.085m-1.745 1.437L5.909 7.5H4.5L2.25 3.75l1.5-1.5L7.5 4.5v1.409l4.26 4.26m-1.745 1.437l1.745-1.437m6.615 8.206L15.75 15.75M4.867 19.125h.008v.008h-.008v-.008z"></path>
                </cfcase>
                <cfcase value="TowerBroadcast">
                    <path stroke-linecap="round" stroke-linejoin="round" d="m15.32,2.84c2.01,1.94,2.07,5.14.13,7.16m3.49-8.84c2.94,2.84,3.02,7.52.19,10.46m-12.57-1.62c-1.94-2.01-1.88-5.22.13-7.16m-3.81,8.78C.04,8.68.12,4,3.06,1.16m7.93,5.59v14.25m0-15.74c-.66,0-1.19.53-1.19,1.19s.53,1.19,1.19,1.19,1.19-.53,1.19-1.19-.53-1.19-1.19-1.19Z"/>
                </cfcase>
                <cfcase value="Trash">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M14.74 9l-.346 9m-4.788 0L9.26 9m9.968-3.21c.342.052.682.107 1.022.166m-1.022-.165L18.16 19.673a2.25 2.25 0 01-2.244 2.077H8.084a2.25 2.25 0 01-2.244-2.077L4.772 5.79m14.456 0a48.108 48.108 0 00-3.478-.397m-12 .562c.34-.059.68-.114 1.022-.165m0 0a48.11 48.11 0 013.478-.397m7.5 0v-.916c0-1.18-.91-2.164-2.09-2.201a51.964 51.964 0 00-3.32 0c-1.18.037-2.09 1.022-2.09 2.201v.916m7.5 0a48.667 48.667 0 00-7.5 0"></path>
                </cfcase>
                <cfcase value="TvGear">
                    <path stroke-linecap="round" stroke-linejoin="round" d="m4.65,19.73h12.69m-7.93-3.17v3.17m3.17-3.17v3.17m-10.71-3.17h18.25c.66,0,1.19-.53,1.19-1.19V3.46c0-.66-.53-1.19-1.19-1.19H1.88c-.66,0-1.19.53-1.19,1.19v11.9c0,.66.53,1.19,1.19,1.19Z"/>
                    <path stroke-linecap="round" stroke-linejoin="round" d="m12.66,9.42c0,.92-.74,1.66-1.66,1.66s-1.66-.74-1.66-1.66.74-1.66,1.66-1.66,1.66.74,1.66,1.66Zm3.34.49v-1l-1.25-.28c-.1-.48-.29-.93-.56-1.32l.69-1.09-.7-.7-1.1.7c-.39-.25-.83-.44-1.3-.54l-.28-1.28h-1l-.28,1.28c-.47.1-.91.28-1.3.54l-1.1-.7-.7.7.69,1.09c-.26.39-.46.84-.56,1.32l-1.25.28v1l1.23.27c.1.49.29.95.55,1.36l-.67,1.05.7.7,1.04-.66c.41.28.88.47,1.38.58l.27,1.2h1l.27-1.2c.5-.1.97-.3,1.38-.58l1.04.66.7-.7-.67-1.05c.27-.41.46-.87.55-1.36l1.23-.27Z"/>
                </cfcase>
                <cfcase value="User">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 6a3.75 3.75 0 11-7.5 0 3.75 3.75 0 017.5 0zM4.501 20.118a7.5 7.5 0 0114.998 0A17.933 17.933 0 0112 21.75c-2.676 0-5.216-.584-7.499-1.632z"></path>
                </cfcase>
                <cfcase value="UserCircle">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M17.982 18.725A7.488 7.488 0 0012 15.75a7.488 7.488 0 00-5.982 2.975m11.963 0a9 9 0 10-11.963 0m11.963 0A8.966 8.966 0 0112 21a8.966 8.966 0 01-5.982-2.275M15 9.75a3 3 0 11-6 0 3 3 0 016 0z"></path>
                </cfcase>
                <cfcase value="Window">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M3 8.25V18a2.25 2.25 0 002.25 2.25h13.5A2.25 2.25 0 0021 18V8.25m-18 0V6a2.25 2.25 0 012.25-2.25h13.5A2.25 2.25 0 0121 6v2.25m-18 0h18M5.25 6h.008v.008H5.25V6zM7.5 6h.008v.008H7.5V6zm2.25 0h.008v.008H9.75V6z"></path>
                </cfcase>
                <cfcase value="WindowArrow">
                    <path stroke-linecap="round" stroke-linejoin="round" d="m2.03,21.28l5.84-8.52m1.13,4.41s.13-5.96.13-5.96l-6.02,1.42"/>
                    <path stroke-linecap="round" stroke-linejoin="round" d="m7.04,19.31h11.69c1.4,0,2.54-1.11,2.54-2.49V6.03M.96,6.03v10.79M.96,6.03v-2.49c0-1.38,1.14-2.49,2.54-2.49h15.23c1.4,0,2.54,1.11,2.54,2.49v2.49M.96,6.03h20.31M3.5,3.54h0s0,0,0,0h0Zm2.54,0h0s0,0,0,0h0Zm2.54,0h0s0,0,0,0h0Z"/>
                </cfcase>
                <cfdefaultcase>
                    <path stroke-linecap="round" stroke-linejoin="round" d="M11.25 11.25l.041-.02a.75.75 0 011.063.852l-.708 2.836a.75.75 0 001.063.853l.041-.021M21 12a9 9 0 11-18 0 9 9 0 0118 0zm-9-3.75h.008v.008H12V8.25z"></path>
                </cfdefaultcase>
            </cfswitch>
        </svg>
    </icon>
</cfoutput>