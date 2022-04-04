<!-- Adminbar Styles -->
<cfoutput>
    <style>
    ##cb-adminbar {
        background: ##333;
        box-shadow: 1px 1px 3px rgba(0, 0, 0, 0.5);
        color: white;
        font-size: .875rem;
        top: 0;
        left: 0;
        padding-right: 10px;
        position: fixed;
        right: 0;
        transition: all 1s ease;
        -moz-transition: all 1s ease;
        -webkit-transition: all 1s ease;
        width: 100%;
        z-index: 9999;
    }
    .cb-adminbar__toggle {
        background: ##333;
        border-radius: 0px 0px 5px 5px;
        padding: 8px;
        position: absolute;
        left: 0px;
        top: 0;
        transition: transform 1s ease;
        -moz-transition: transform 1s ease;
        -webkit-transition: transform 1s ease;
    }
    .slide_out .cb-adminbar__toggle {
        box-shadow: 2px 2px 4px rgb(0 0 0 / 20%); 
        transform: translateY( 100% );
    }
    .slide_out .cb-adminbar__toggle .svg-cheveron {
        transform: rotate( 180deg );
    }
    .cb-adminbar__content {
        display: flex;
    }
    .cb-adminbar__brand {
        padding: 0.5rem;
        margin-left: 40px;
        cursor: pointer;
    }
    .cb-adminbar__menu {
        display: flex;
        list-style: none;
        margin: 0px;
    } 
    .cb-adminbar__icon {
        display: inline-block;
        margin-right: 5px;
        width: 14px;
    }
    .cb-adminbar__brand .cb-adminbar__icon{
        width: 20px;
        margin-right: 0px; 
    }
    .cb-adminbar-popover-trigger, .cb-adminbar__dropdown-toggle {
        padding: 0.5rem
    }
    .cb-adminbar-popover-trigger:hover + .cb-adminbar-popover, .cb-adminbar-popover-trigger:focus + .cb-adminbar-popover{
        display: block;
    }
    .cb-adminbar__menu-item a, .cb-adminbar__menu-item button, .cb-adminbar__brand {
        color: ##fff;
        display: inline-block;
        line-height: 25px;
        padding: 0.5rem;
    }
    
    .cb-adminbar__brand:hover, 
    .cb-adminbar__brand:focus, 
    .cb-adminbar__menu-item a:hover, 
    .cb-adminbar__menu-item a:focus,
    .cb-adminbar__menu-item button:hover,
    .cb-adminbar__menu-item button:focus {
        background: ##222;
        color: ##8fc73e;
        text-decoration: none;
    }
    .cb-adminbar__dropdown-menu ul {
        border-top: 1px solid ##3f3f3f;
        list-style: none;
        margin: 0px;
        margin-top: 10px;
        padding: 0px;
    }
    .cb-adminbar__dropdown-menu ul > li a {
        color: ##fff;
        display: block;
        padding: 0.5rem;
    }
    .cb-adminbar__dropdown-menu ul > li a:hover {
        background-color: ##222;
        color: ##8fc73e;
        text-decoration: none;
    }
    .cb-adminbar__dropdown.active .cb-adminbar__dropdown-menu {
        display: block;
    }
    .cb-adminbar-popover, .cb-adminbar__dropdown-menu {
        position: absolute;
        background: rgba(60,64,67,0.90);
        -webkit-border-radius: 4px;
        border-radius: 4px;
        max-width: 250px;
        padding: 0.5rem; 
        z-index: 1000;
        display: none;
    }
    .publisher img {
        display: inline-block;
    }
    ##avatar {
        display: flex;
        align-items: center;
    }
    ##avatar .cb-adminbar__dropdown-menu {
        right: 20px;
    }
    
    
    .slide_out {
        transform: translateY( -100% );
    }
    ##cb-adminbar .admin-bar-label-red{
        background-color: red;
        padding: 3px;
        margin-right: 5px;
        border: 2px solid;
        border-radius: 10px;
    }
    ##cb-adminbar .admin-bar-label{
        /*background-color: ##3598db;*/
        padding: 3px;
        margin-right: 5px;
        /*border: 2px solid;*/
        border-radius: 10px;
    }
    
    /* responsive */
    /* @media (max-width: 1400px) {} */
    
    /* @media (max-width: 1200px) {
        .admin-bar-label.layout, .admin-bar-label.comments, .admin-bar-label.hits, .admin-bar-label.publisher, .icon-info{
            display: none;
        }
    } */
    
    @media ( max-width: 1023px) {
        .cb-adminbar__menu-item .menu-heading {
          display: none;
        }
    }
    @media (max-width: 768px) {
        .cb-adminbar__menu-item .custom_fields, .cb-adminbar__menu-item .seo, .cb-adminbar__menu-item .history{
          display: none;
        }
    }
    @media ( min-width: 478px ) {
        ##cb-adminbar__actions {
            flex-grow: 2;
        }
    }
    @media (max-width: 479px) {
        .cb-adminbar__content {
            justify-content: space-between;
        }
        ##cb-adminbar__actions {
              display: none;
        }
    }
    
    .cb-adminbar__toggle .svg-cheveron {
        height: 20px;
        width: 20px;
        transition: all 1s ease;
        -moz-transition: all 1s ease;
        -webkit-transition: all 1s ease;
    
    }
    </style>
</cfoutput>