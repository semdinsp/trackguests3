defmodule Trackguests3Web.GuidesLive do
  use Trackguests3Web, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "User Guides")
     |> assign(:current_section, "overview")}
  end

  @impl true
  def handle_event("show_section", %{"section" => section}, socket) do
    {:noreply, assign(socket, :current_section, section)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-gradient-to-br from-gray-50 to-blue-50">
      <!-- Header Section -->
      <div class="bg-white shadow-sm border-b border-gray-200">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 relative">
          <!-- Back to Home Link - Top Right -->
          <div class="absolute top-4 right-4 sm:right-6 lg:right-8">
            <a href="/" class="flex items-center space-x-2 text-gray-600 hover:text-gray-900 transition-colors duration-200 group">
              <div class="w-10 h-10 gradient-header-luxury rounded-xl flex items-center justify-center group-hover:shadow-luxury transition-all duration-300">
                <span class="text-white font-bold text-sm tracking-wide">TG</span>
              </div>
              <span class="text-sm font-medium hidden sm:inline">Back to Home</span>
            </a>
          </div>
          
          <div class="text-center">
            <div class="w-20 h-20 gradient-header-luxury rounded-3xl flex items-center justify-center mx-auto mb-6 shadow-luxury">
              <svg class="w-10 h-10 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.746 0 3.332.477 4.5 1.253v13C19.832 18.477 18.246 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"/>
              </svg>
            </div>
            <h1 class="page-title-luxury text-platinum">TrackGuests User Guides</h1>
            <p class="page-subtitle-luxury max-w-3xl mx-auto">
              Comprehensive guides to help you make the most of your guest management system. 
              Learn how to check in guests, manage properties, and utilize all available features.
            </p>
          </div>
        </div>
      </div>

      <!-- Navigation Tabs -->
      <div class="bg-white border-b border-gray-200 sticky top-0 z-10">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <nav class="flex space-x-8" aria-label="Tabs">
            <button
              phx-click="show_section"
              phx-value-section="overview"
              class={[
                "py-4 px-1 border-b-2 font-medium text-sm transition-colors duration-200",
                if(@current_section == "overview", 
                  do: "border-purple-500 text-purple-600", 
                  else: "border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300")
              ]}
            >
              <svg class="w-4 h-4 inline mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
              </svg>
              Overview
            </button>
            <button
              phx-click="show_section"
              phx-value-section="check-in"
              class={[
                "py-4 px-1 border-b-2 font-medium text-sm transition-colors duration-200",
                if(@current_section == "check-in", 
                  do: "border-purple-500 text-purple-600", 
                  else: "border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300")
              ]}
            >
              <svg class="w-4 h-4 inline mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"/>
              </svg>
              Guest Check-In
            </button>
            <button
              phx-click="show_section"
              phx-value-section="check-out"
              class={[
                "py-4 px-1 border-b-2 font-medium text-sm transition-colors duration-200",
                if(@current_section == "check-out", 
                  do: "border-purple-500 text-purple-600", 
                  else: "border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300")
              ]}
            >
              <svg class="w-4 h-4 inline mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"/>
              </svg>
              Guest Check-Out
            </button>
            <button
              phx-click="show_section"
              phx-value-section="features"
              class={[
                "py-4 px-1 border-b-2 font-medium text-sm transition-colors duration-200",
                if(@current_section == "features", 
                  do: "border-purple-500 text-purple-600", 
                  else: "border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300")
              ]}
            >
              <svg class="w-4 h-4 inline mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.663 17h4.673M12 3v1m6.364 1.636l-.707.707M21 12h-1M4 12H3m3.343-5.657l-.707-.707m2.828 9.9a5 5 0 117.072 0l-.548.547A3.374 3.374 0 0014 18.469V19a2 2 0 11-4 0v-.531c0-.895-.356-1.754-.988-2.386l-.548-.547z"/>
              </svg>
              Features
            </button>
            <button
              phx-click="show_section"
              phx-value-section="admin"
              class={[
                "py-4 px-1 border-b-2 font-medium text-sm transition-colors duration-200",
                if(@current_section == "admin", 
                  do: "border-purple-500 text-purple-600", 
                  else: "border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300")
              ]}
            >
              <svg class="w-4 h-4 inline mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"/>
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
              </svg>
              Admin Guide
            </button>
          </nav>
        </div>
      </div>

      <!-- Content Section -->
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <%= case @current_section do %>
          <% "overview" -> %>
            <.overview_section assigns={assigns} />
          <% "check-in" -> %>
            <.check_in_section assigns={assigns} />
          <% "check-out" -> %>
            <.check_out_section assigns={assigns} />
          <% "features" -> %>
            <.features_section assigns={assigns} />
          <% "admin" -> %>
            <.admin_section assigns={assigns} />
        <% end %>
      </div>

      <!-- Footer -->
      <div class="bg-white border-t border-gray-200 mt-20">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
          <div class="text-center">
            <h3 class="text-lg font-semibold text-gray-900 mb-4">Need More Help?</h3>
            <p class="text-gray-600 mb-6">
              Can't find what you're looking for? Contact your system administrator for additional support.
            </p>
            <div class="flex justify-center space-x-6">
              <a href="/" class="btn-secondary-luxury">
                <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"/>
                </svg>
                Return to Dashboard
              </a>
              <a href="/visitor/check-in" class="btn-luxury">
                <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"/>
                </svg>
                Start Guest Check-In
              </a>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  # Overview Section Component
  defp overview_section(assigns) do
    ~H"""
    <div class="space-y-8">
      <div class="text-center">
        <h2 class="text-3xl font-bold text-gray-900 mb-4">Welcome to TrackGuests</h2>
        <p class="text-xl text-gray-600 max-w-3xl mx-auto">
          TrackGuests is a comprehensive guest management system designed to streamline visitor check-ins and check-outs 
          for residential properties, office buildings, and hospitality venues.
        </p>
      </div>

      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
        <div class="card-luxury">
          <div class="w-12 h-12 bg-gradient-to-r from-blue-500 to-purple-600 rounded-xl flex items-center justify-center mb-4">
            <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"/>
            </svg>
          </div>
          <h3 class="text-lg font-semibold text-gray-900 mb-2">Quick & Easy</h3>
          <p class="text-gray-600">
            Streamlined check-in process that takes just minutes. Visitors can easily register their arrival and departure.
          </p>
        </div>

        <div class="card-luxury">
          <div class="w-12 h-12 bg-gradient-to-r from-green-500 to-teal-600 rounded-xl flex items-center justify-center mb-4">
            <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"/>
            </svg>
          </div>
          <h3 class="text-lg font-semibold text-gray-900 mb-2">Secure & Reliable</h3>
          <p class="text-gray-600">
            Advanced security features ensure visitor data is protected while maintaining detailed logs for compliance.
          </p>
        </div>

        <div class="card-luxury">
          <div class="w-12 h-12 bg-gradient-to-r from-orange-500 to-red-600 rounded-xl flex items-center justify-center mb-4">
            <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"/>
            </svg>
          </div>
          <h3 class="text-lg font-semibold text-gray-900 mb-2">Real-time Analytics</h3>
          <p class="text-gray-600">
            Monitor visitor patterns, occupancy rates, and generate comprehensive reports for better management.
          </p>
        </div>
      </div>

      <div class="bg-gradient-to-r from-purple-50 to-blue-50 rounded-2xl p-8">
        <h3 class="text-2xl font-bold text-gray-900 mb-4">Getting Started</h3>
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div>
            <h4 class="font-semibold text-gray-900 mb-2">For Visitors</h4>
            <ul class="space-y-2 text-gray-600">
              <li class="flex items-center">
                <svg class="w-4 h-4 text-green-500 mr-2" fill="currentColor" viewBox="0 0 20 20">
                  <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
                </svg>
                Navigate to the Check-In page
              </li>
              <li class="flex items-center">
                <svg class="w-4 h-4 text-green-500 mr-2" fill="currentColor" viewBox="0 0 20 20">
                  <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
                </svg>
                Fill in your contact information
              </li>
              <li class="flex items-center">
                <svg class="w-4 h-4 text-green-500 mr-2" fill="currentColor" viewBox="0 0 20 20">
                  <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
                </svg>
                Select your destination room
              </li>
              <li class="flex items-center">
                <svg class="w-4 h-4 text-green-500 mr-2" fill="currentColor" viewBox="0 0 20 20">
                  <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
                </svg>
                Complete check-in and receive confirmation
              </li>
            </ul>
          </div>
          <div>
            <h4 class="font-semibold text-gray-900 mb-2">For Property Managers</h4>
            <ul class="space-y-2 text-gray-600">
              <li class="flex items-center">
                <svg class="w-4 h-4 text-blue-500 mr-2" fill="currentColor" viewBox="0 0 20 20">
                  <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
                </svg>
                Monitor real-time visitor status
              </li>
              <li class="flex items-center">
                <svg class="w-4 h-4 text-blue-500 mr-2" fill="currentColor" viewBox="0 0 20 20">
                  <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
                </svg>
                Manage properties and rooms
              </li>
              <li class="flex items-center">
                <svg class="w-4 h-4 text-blue-500 mr-2" fill="currentColor" viewBox="0 0 20 20">
                  <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
                </svg>
                Generate comprehensive reports
              </li>
              <li class="flex items-center">
                <svg class="w-4 h-4 text-blue-500 mr-2" fill="currentColor" viewBox="0 0 20 20">
                  <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
                </svg>
                Configure system settings
              </li>
            </ul>
          </div>
        </div>
      </div>
    </div>
    """
  end

  # Check-In Section Component
  defp check_in_section(assigns) do
    ~H"""
    <div class="space-y-8">
      <div class="text-center">
        <h2 class="text-3xl font-bold text-gray-900 mb-4">Guest Check-In Process</h2>
        <p class="text-xl text-gray-600 max-w-3xl mx-auto">
          Follow this step-by-step guide to quickly and efficiently check in visitors to your property.
        </p>
      </div>

      <div class="grid grid-cols-1 lg:grid-cols-2 gap-12">
        <!-- Step-by-step Process -->
        <div class="space-y-6">
          <h3 class="text-2xl font-semibold text-gray-900 mb-6">Step-by-Step Instructions</h3>
          
          <div class="space-y-6">
            <div class="flex items-start space-x-4">
              <div class="w-8 h-8 bg-purple-600 text-white rounded-full flex items-center justify-center font-bold text-sm flex-shrink-0">1</div>
              <div>
                <h4 class="font-semibold text-gray-900 mb-2">Navigate to Check-In</h4>
                <p class="text-gray-600">
                  Access the guest check-in page either from the main dashboard or directly via the check-in URL. 
                  The page is accessible to both authenticated users and public visitors.
                </p>
              </div>
            </div>

            <div class="flex items-start space-x-4">
              <div class="w-8 h-8 bg-purple-600 text-white rounded-full flex items-center justify-center font-bold text-sm flex-shrink-0">2</div>
              <div>
                <h4 class="font-semibold text-gray-900 mb-2">Select Property (if applicable)</h4>
                <p class="text-gray-600">
                  If checking in to a specific property, select it from the dropdown menu. 
                  Property managers will see their assigned property highlighted.
                </p>
              </div>
            </div>

            <div class="flex items-start space-x-4">
              <div class="w-8 h-8 bg-purple-600 text-white rounded-full flex items-center justify-center font-bold text-sm flex-shrink-0">3</div>
              <div>
                <h4 class="font-semibold text-gray-900 mb-2">Enter Guest Information</h4>
                <p class="text-gray-600">
                  Complete the required fields including full name, email address, phone number, and company/organization if applicable.
                </p>
              </div>
            </div>

            <div class="flex items-start space-x-4">
              <div class="w-8 h-8 bg-purple-600 text-white rounded-full flex items-center justify-center font-bold text-sm flex-shrink-0">4</div>
              <div>
                <h4 class="font-semibold text-gray-900 mb-2">Select Destination Room</h4>
                <p class="text-gray-600">
                  Use the room search feature to find and select the visitor's destination. 
                  You can search by room name, floor number, or building area.
                </p>
              </div>
            </div>

            <div class="flex items-start space-x-4">
              <div class="w-8 h-8 bg-purple-600 text-white rounded-full flex items-center justify-center font-bold text-sm flex-shrink-0">5</div>
              <div>
                <h4 class="font-semibold text-gray-900 mb-2">Add Visit Details</h4>
                <p class="text-gray-600">
                  Specify the visitor type (visitor, staff, resident), purpose of visit, and any special notes or requirements.
                </p>
              </div>
            </div>

            <div class="flex items-start space-x-4">
              <div class="w-8 h-8 bg-green-600 text-white rounded-full flex items-center justify-center font-bold text-sm flex-shrink-0">✓</div>
              <div>
                <h4 class="font-semibold text-gray-900 mb-2">Complete Check-In</h4>
                <p class="text-gray-600">
                  Review all information and click "Complete Check-In" to finalize the process. 
                  The visitor will receive confirmation and be logged in the system.
                </p>
              </div>
            </div>
          </div>
        </div>

        <!-- Visual Guide -->
        <div class="space-y-6">
          <h3 class="text-2xl font-semibold text-gray-900 mb-6">Key Features</h3>

          <div class="card-luxury">
            <div class="flex items-center mb-4">
              <div class="w-8 h-8 bg-blue-100 text-blue-600 rounded-lg flex items-center justify-center mr-3">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
                </svg>
              </div>
              <h4 class="font-semibold text-gray-900">Smart Room Search</h4>
            </div>
            <p class="text-gray-600">
              The intelligent room search feature allows you to quickly find rooms by typing partial names, 
              floor numbers, or building areas. Results are filtered in real-time as you type.
            </p>
          </div>

          <div class="card-luxury">
            <div class="flex items-center mb-4">
              <div class="w-8 h-8 bg-green-100 text-green-600 rounded-lg flex items-center justify-center mr-3">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                </svg>
              </div>
              <h4 class="font-semibold text-gray-900">Form Validation</h4>
            </div>
            <p class="text-gray-600">
              Real-time form validation ensures all required information is provided correctly 
              before allowing check-in completion, reducing errors and improving data quality.
            </p>
          </div>

          <div class="card-luxury">
            <div class="flex items-center mb-4">
              <div class="w-8 h-8 bg-purple-100 text-purple-600 rounded-lg flex items-center justify-center mr-3">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 18h.01M8 21h8a2 2 0 002-2V5a2 2 0 00-2-2H8a2 2 0 00-2 2v14a2 2 0 002 2z"/>
                </svg>
              </div>
              <h4 class="font-semibold text-gray-900">Mobile Optimized</h4>
            </div>
            <p class="text-gray-600">
              The check-in interface is fully responsive and optimized for mobile devices, 
              allowing visitors to check in using their smartphones or tablets.
            </p>
          </div>

          <div class="card-luxury">
            <div class="flex items-center mb-4">
              <div class="w-8 h-8 bg-orange-100 text-orange-600 rounded-lg flex items-center justify-center mr-3">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"/>
                </svg>
              </div>
              <h4 class="font-semibold text-gray-900">Key Fob Integration</h4>
            </div>
            <p class="text-gray-600">
              For rooms requiring key fob access, the system can track and associate 
              fob IDs with visitor check-ins for enhanced security and access control.
            </p>
          </div>
        </div>
      </div>

      <!-- Tips Section -->
      <div class="bg-blue-50 rounded-2xl p-8">
        <h3 class="text-xl font-semibold text-gray-900 mb-4 flex items-center">
          <svg class="w-5 h-5 text-blue-600 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.663 17h4.673M12 3v1m6.364 1.636l-.707.707M21 12h-1M4 12H3m3.343-5.657l-.707-.707m2.828 9.9a5 5 0 117.072 0l-.548.547A3.374 3.374 0 0014 18.469V19a2 2 0 11-4 0v-.531c0-.895-.356-1.754-.988-2.386l-.548-.547z"/>
          </svg>
          Pro Tips for Efficient Check-In
        </h3>
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div>
            <h4 class="font-medium text-gray-900 mb-2">⚡ Speed Up the Process</h4>
            <ul class="text-sm text-gray-600 space-y-1">
              <li>• Have visitor information ready before starting</li>
              <li>• Use the room search to quickly find destinations</li>
              <li>• Pre-fill common visitor types for recurring guests</li>
            </ul>
          </div>
          <div>
            <h4 class="font-medium text-gray-900 mb-2">🎯 Ensure Accuracy</h4>
            <ul class="text-sm text-gray-600 space-y-1">
              <li>• Double-check email addresses for notifications</li>
              <li>• Verify room selection matches visitor's destination</li>
              <li>• Include purpose of visit for better tracking</li>
            </ul>
          </div>
        </div>
      </div>
    </div>
    """
  end

  # Check-Out Section Component  
  defp check_out_section(assigns) do
    ~H"""
    <div class="space-y-8">
      <div class="text-center">
        <h2 class="text-3xl font-bold text-gray-900 mb-4">Guest Check-Out Process</h2>
        <p class="text-xl text-gray-600 max-w-3xl mx-auto">
          Learn how to efficiently process visitor departures and maintain accurate visit records.
        </p>
      </div>

      <div class="grid grid-cols-1 lg:grid-cols-2 gap-12">
        <!-- Process Steps -->
        <div class="space-y-6">
          <h3 class="text-2xl font-semibold text-gray-900 mb-6">How to Check Out Visitors</h3>
          
          <div class="space-y-6">
            <div class="flex items-start space-x-4">
              <div class="w-8 h-8 bg-red-600 text-white rounded-full flex items-center justify-center font-bold text-sm flex-shrink-0">1</div>
              <div>
                <h4 class="font-semibold text-gray-900 mb-2">Access Check-Out Page</h4>
                <p class="text-gray-600">
                  Navigate to the guest check-out page from the main menu or directly via the check-out URL. 
                  The page displays all currently checked-in visitors.
                </p>
              </div>
            </div>

            <div class="flex items-start space-x-4">
              <div class="w-8 h-8 bg-red-600 text-white rounded-full flex items-center justify-center font-bold text-sm flex-shrink-0">2</div>
              <div>
                <h4 class="font-semibold text-gray-900 mb-2">Review Active Visitors</h4>
                <p class="text-gray-600">
                  View the list of all currently checked-in visitors, including their names, 
                  companies, room assignments, check-in times, and visit purposes.
                </p>
              </div>
            </div>

            <div class="flex items-start space-x-4">
              <div class="w-8 h-8 bg-red-600 text-white rounded-full flex items-center justify-center font-bold text-sm flex-shrink-0">3</div>
              <div>
                <h4 class="font-semibold text-gray-900 mb-2">Select Visitor to Check Out</h4>
                <p class="text-gray-600">
                  Find the visitor who is ready to leave and click the "Check Out" button next to their information. 
                  Each visitor card shows all relevant details for easy identification.
                </p>
              </div>
            </div>

            <div class="flex items-start space-x-4">
              <div class="w-8 h-8 bg-green-600 text-white rounded-full flex items-center justify-center font-bold text-sm flex-shrink-0">✓</div>
              <div>
                <h4 class="font-semibold text-gray-900 mb-2">Confirm Check-Out</h4>
                <p class="text-gray-600">
                  The system will process the check-out immediately, update the visitor's status, 
                  and provide confirmation. The visitor record is preserved for reporting purposes.
                </p>
              </div>
            </div>
          </div>
        </div>

        <!-- Visual Elements -->
        <div class="space-y-6">
          <h3 class="text-2xl font-semibold text-gray-900 mb-6">Check-Out Features</h3>

          <div class="card-luxury">
            <div class="flex items-center mb-4">
              <div class="w-8 h-8 bg-red-100 text-red-600 rounded-lg flex items-center justify-center mr-3">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/>
                </svg>
              </div>
              <h4 class="font-semibold text-gray-900">Real-Time Status</h4>
            </div>
            <p class="text-gray-600">
              View live updates of all checked-in visitors with check-in times, duration of stay, 
              and current status. The list automatically updates as visitors check in and out.
            </p>
          </div>

          <div class="card-luxury">
            <div class="flex items-center mb-4">
              <div class="w-8 h-8 bg-blue-100 text-blue-600 rounded-lg flex items-center justify-center mr-3">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                </svg>
              </div>
              <h4 class="font-semibold text-gray-900">Visitor Information Cards</h4>
            </div>
            <p class="text-gray-600">
              Each visitor is displayed in an easy-to-read card format showing name, company, 
              room assignment, check-in time, and purpose of visit for quick identification.
            </p>
          </div>

          <div class="card-luxury">
            <div class="flex items-center mb-4">
              <div class="w-8 h-8 bg-green-100 text-green-600 rounded-lg flex items-center justify-center mr-3">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                </svg>
              </div>
              <h4 class="font-semibold text-gray-900">Instant Processing</h4>
            </div>
            <p class="text-gray-600">
              Check-out processing is instantaneous with immediate confirmation. 
              The system automatically calculates visit duration and updates all relevant records.
            </p>
          </div>

          <div class="card-luxury">
            <div class="flex items-center mb-4">
              <div class="w-8 h-8 bg-purple-100 text-purple-600 rounded-lg flex items-center justify-center mr-3">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 17V7m0 10a2 2 0 01-2 2H5a2 2 0 01-2-2V7a2 2 0 012-2h2a2 2 0 012 2m0 10a2 2 0 002 2h2a2 2 0 002-2M9 7a2 2 0 012-2h2a2 2 0 012 2m0 10V7m0 10a2 2 0 002 2h2a2 2 0 002-2V7a2 2 0 00-2-2h-2a2 2 0 00-2 2"/>
                </svg>
              </div>
              <h4 class="font-semibold text-gray-900">Visit History</h4>
            </div>
            <p class="text-gray-600">
              All check-out activities are logged with timestamps for comprehensive 
              visit tracking, compliance reporting, and historical analysis.
            </p>
          </div>
        </div>
      </div>

      <!-- Special Scenarios -->
      <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
        <div class="bg-yellow-50 rounded-2xl p-6">
          <h3 class="text-lg font-semibold text-gray-900 mb-4 flex items-center">
            <svg class="w-5 h-5 text-yellow-600 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-2.5L13.732 4c-.77-.833-1.964-.833-2.732 0L3.732 16.5c-.77.833.192 2.5 1.732 2.5z"/>
            </svg>
            No Active Visitors
          </h3>
          <p class="text-gray-600 mb-4">
            When no visitors are currently checked in, the system displays a helpful message 
            with options to navigate to the check-in page or return to the dashboard.
          </p>
          <div class="text-sm text-gray-500">
            This ensures users always have clear next steps and can easily transition between check-in and check-out processes.
          </div>
        </div>

        <div class="bg-blue-50 rounded-2xl p-6">
          <h3 class="text-lg font-semibold text-gray-900 mb-4 flex items-center">
            <svg class="w-5 h-5 text-blue-600 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
            </svg>
            Room Information Handling
          </h3>
          <p class="text-gray-600 mb-4">
            If room details are unavailable, the system gracefully displays the room ID 
            and continues processing the check-out without interruption.
          </p>
          <div class="text-sm text-gray-500">
            This robust error handling ensures the check-out process always works, even if there are data inconsistencies.
          </div>
        </div>
      </div>

      <!-- Best Practices -->
      <div class="bg-green-50 rounded-2xl p-8">
        <h3 class="text-xl font-semibold text-gray-900 mb-4 flex items-center">
          <svg class="w-5 h-5 text-green-600 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
          </svg>
          Check-Out Best Practices
        </h3>
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
          <div>
            <h4 class="font-medium text-gray-900 mb-2">🕒 Timely Processing</h4>
            <p class="text-sm text-gray-600">
              Process check-outs promptly when visitors depart to maintain accurate occupancy data 
              and ensure security compliance.
            </p>
          </div>
          <div>
            <h4 class="font-medium text-gray-900 mb-2">✅ Verify Identity</h4>
            <p class="text-sm text-gray-600">
              Confirm visitor identity before processing check-out, especially in high-security 
              environments or when multiple visitors have similar names.
            </p>
          </div>
          <div>
            <h4 class="font-medium text-gray-900 mb-2">📊 Monitor Patterns</h4>
            <p class="text-sm text-gray-600">
              Review check-out patterns regularly to identify trends, optimize processes, 
              and improve overall visitor experience.
            </p>
          </div>
        </div>
      </div>
    </div>
    """
  end

  # Features Section Component
  defp features_section(assigns) do
    ~H"""
    <div class="space-y-8">
      <div class="text-center">
        <h2 class="text-3xl font-bold text-gray-900 mb-4">Platform Features</h2>
        <p class="text-xl text-gray-600 max-w-3xl mx-auto">
          Discover the comprehensive features that make TrackGuests a powerful solution for visitor management.
        </p>
      </div>

      <!-- Core Features Grid -->
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
        <div class="card-luxury">
          <div class="w-12 h-12 bg-gradient-to-r from-blue-500 to-blue-600 rounded-xl flex items-center justify-center mb-4">
            <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"/>
            </svg>
          </div>
          <h3 class="text-lg font-semibold text-gray-900 mb-2">Visitor Management</h3>
          <p class="text-gray-600 mb-4">
            Complete visitor lifecycle management from check-in to check-out with detailed tracking and reporting.
          </p>
          <ul class="text-sm text-gray-500 space-y-1">
            <li>• Quick check-in/check-out process</li>
            <li>• Visitor information capture</li>
            <li>• Real-time status tracking</li>
            <li>• Visit duration monitoring</li>
          </ul>
        </div>

        <div class="card-luxury">
          <div class="w-12 h-12 bg-gradient-to-r from-green-500 to-green-600 rounded-xl flex items-center justify-center mb-4">
            <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"/>
            </svg>
          </div>
          <h3 class="text-lg font-semibold text-gray-900 mb-2">Property & Room Management</h3>
          <p class="text-gray-600 mb-4">
            Organize and manage multiple properties, buildings, and individual rooms with hierarchical structure.
          </p>
          <ul class="text-sm text-gray-500 space-y-1">
            <li>• Multi-property support</li>
            <li>• Room categorization and search</li>
            <li>• Floor-based organization</li>
            <li>• Guest access permissions</li>
          </ul>
        </div>

        <div class="card-luxury">
          <div class="w-12 h-12 bg-gradient-to-r from-purple-500 to-purple-600 rounded-xl flex items-center justify-center mb-4">
            <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"/>
            </svg>
          </div>
          <h3 class="text-lg font-semibold text-gray-900 mb-2">Analytics & Reporting</h3>
          <p class="text-gray-600 mb-4">
            Comprehensive dashboard with real-time analytics, occupancy tracking, and detailed reporting capabilities.
          </p>
          <ul class="text-sm text-gray-500 space-y-1">
            <li>• Real-time dashboard metrics</li>
            <li>• Occupancy rate calculations</li>
            <li>• Visit pattern analysis</li>
            <li>• Historical reporting</li>
          </ul>
        </div>

        <div class="card-luxury">
          <div class="w-12 h-12 bg-gradient-to-r from-red-500 to-red-600 rounded-xl flex items-center justify-center mb-4">
            <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"/>
            </svg>
          </div>
          <h3 class="text-lg font-semibold text-gray-900 mb-2">Security & Access Control</h3>
          <p class="text-gray-600 mb-4">
            Advanced security features including user roles, property-based access control, and key fob integration.
          </p>
          <ul class="text-sm text-gray-500 space-y-1">
            <li>• Role-based access control</li>
            <li>• Property-specific permissions</li>
            <li>• Key fob tracking</li>
            <li>• Secure visitor data handling</li>
          </ul>
        </div>

        <div class="card-luxury">
          <div class="w-12 h-12 bg-gradient-to-r from-yellow-500 to-yellow-600 rounded-xl flex items-center justify-center mb-4">
            <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 5h12M9 3v2m1.048 9.5A18.022 18.022 0 016.412 9m6.088 9h7M11 21l5-10 5 10M12.751 5C11.783 10.77 8.07 15.61 3 18.129"/>
            </svg>
          </div>
          <h3 class="text-lg font-semibold text-gray-900 mb-2">Multi-language Support</h3>
          <p class="text-gray-600 mb-4">
            Comprehensive internationalization with support for 11 languages and user-configurable language preferences.
          </p>
          <ul class="text-sm text-gray-500 space-y-1">
            <li>• 11 supported languages</li>
            <li>• Dynamic language switching</li>
            <li>• User preference settings</li>
            <li>• Localized visitor interfaces</li>
          </ul>
        </div>

        <div class="card-luxury">
          <div class="w-12 h-12 bg-gradient-to-r from-indigo-500 to-indigo-600 rounded-xl flex items-center justify-center mb-4">
            <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 18h.01M8 21h8a2 2 0 002-2V5a2 2 0 00-2-2H8a2 2 0 00-2 2v14a2 2 0 002 2z"/>
            </svg>
          </div>
          <h3 class="text-lg font-semibold text-gray-900 mb-2">Mobile Responsive</h3>
          <p class="text-gray-600 mb-4">
            Fully responsive design optimized for desktop, tablet, and mobile devices with touch-friendly interfaces.
          </p>
          <ul class="text-sm text-gray-500 space-y-1">
            <li>• Mobile-first design</li>
            <li>• Touch-optimized controls</li>
            <li>• Responsive layouts</li>
            <li>• Cross-platform compatibility</li>
          </ul>
        </div>
      </div>

      <!-- Advanced Features -->
      <div class="bg-gray-900 text-white rounded-2xl p-8 mt-12">
        <h3 class="text-2xl font-bold mb-6">Advanced Capabilities</h3>
        <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
          <div>
            <h4 class="text-lg font-semibold mb-4 text-blue-300">Real-time Updates</h4>
            <ul class="space-y-2 text-gray-300">
              <li class="flex items-center">
                <svg class="w-4 h-4 text-green-400 mr-2" fill="currentColor" viewBox="0 0 20 20">
                  <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
                </svg>
                Live dashboard updates via WebSocket connections
              </li>
              <li class="flex items-center">
                <svg class="w-4 h-4 text-green-400 mr-2" fill="currentColor" viewBox="0 0 20 20">
                  <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
                </svg>
                Instant visitor status synchronization
              </li>
              <li class="flex items-center">
                <svg class="w-4 h-4 text-green-400 mr-2" fill="currentColor" viewBox="0 0 20 20">
                  <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
                </svg>
                Automated metric calculations and display
              </li>
            </ul>
          </div>
          <div>
            <h4 class="text-lg font-semibold mb-4 text-purple-300">Data Management</h4>
            <ul class="space-y-2 text-gray-300">
              <li class="flex items-center">
                <svg class="w-4 h-4 text-green-400 mr-2" fill="currentColor" viewBox="0 0 20 20">
                  <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
                </svg>
                Comprehensive visitor history tracking
              </li>
              <li class="flex items-center">
                <svg class="w-4 h-4 text-green-400 mr-2" fill="currentColor" viewBox="0 0 20 20">
                  <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
                </svg>
                Automated data validation and error handling
              </li>
              <li class="flex items-center">
                <svg class="w-4 h-4 text-green-400 mr-2" fill="currentColor" viewBox="0 0 20 20">
                  <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
                </svg>
                Scalable database architecture for growth
              </li>
            </ul>
          </div>
        </div>
      </div>

      <!-- Integration Capabilities -->
      <div class="bg-gradient-to-r from-blue-50 to-purple-50 rounded-2xl p-8">
        <h3 class="text-2xl font-bold text-gray-900 mb-6">Integration & Compatibility</h3>
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
          <div class="text-center">
            <div class="w-16 h-16 bg-blue-100 rounded-full flex items-center justify-center mx-auto mb-4">
              <svg class="w-8 h-8 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 3v2m6-2v2m-10 4h14m-5 0a3 3 0 006 0m-6 0a3 3 0 00-6 0m3 7h6m-3 0v4"/>
              </svg>
            </div>
            <h4 class="font-semibold text-gray-900 mb-2">API Ready</h4>
            <p class="text-gray-600 text-sm">
              Built with modern REST APIs for seamless integration with existing systems and third-party applications.
            </p>
          </div>
          <div class="text-center">
            <div class="w-16 h-16 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-4">
              <svg class="w-8 h-8 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 12h14M5 12a2 2 0 01-2-2V6a2 2 0 012-2h14a2 2 0 012 2v4a2 2 0 01-2 2M5 12a2 2 0 00-2 2v4a2 2 0 002 2h14a2 2 0 002-2v-4a2 2 0 00-2-2m-2-4h.01M17 16h.01"/>
              </svg>
            </div>
            <h4 class="font-semibold text-gray-900 mb-2">Cloud Native</h4>
            <p class="text-gray-600 text-sm">
              Designed for cloud deployment with scalable infrastructure supporting multi-tenant environments.
            </p>
          </div>
          <div class="text-center">
            <div class="w-16 h-16 bg-purple-100 rounded-full flex items-center justify-center mx-auto mb-4">
              <svg class="w-8 h-8 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"/>
              </svg>
            </div>
            <h4 class="font-semibold text-gray-900 mb-2">Security First</h4>
            <p class="text-gray-600 text-sm">
              Enterprise-grade security with encryption, secure authentication, and compliance-ready audit trails.
            </p>
          </div>
        </div>
      </div>
    </div>
    """
  end

  # Admin Section Component
  defp admin_section(assigns) do
    ~H"""
    <div class="space-y-8">
      <div class="text-center">
        <h2 class="text-3xl font-bold text-gray-900 mb-4">Administrator Guide</h2>
        <p class="text-xl text-gray-600 max-w-3xl mx-auto">
          Comprehensive guide for system administrators to manage users, properties, and system configuration.
        </p>
      </div>

      <!-- Admin Overview -->
      <div class="grid grid-cols-1 lg:grid-cols-2 gap-12">
        <div class="space-y-6">
          <h3 class="text-2xl font-semibold text-gray-900">Administrative Capabilities</h3>
          <p class="text-gray-600">
            As a system administrator, you have full access to all platform features and management capabilities. 
            Use these tools to configure the system, manage users, and maintain optimal performance.
          </p>

          <div class="space-y-4">
            <div class="flex items-start space-x-3">
              <div class="w-6 h-6 bg-blue-100 text-blue-600 rounded-full flex items-center justify-center flex-shrink-0">
                <svg class="w-3 h-3" fill="currentColor" viewBox="0 0 20 20">
                  <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
                </svg>
              </div>
              <div>
                <h4 class="font-semibold text-gray-900">Global System Access</h4>
                <p class="text-gray-600 text-sm">View all properties, rooms, and visitor data across the entire system</p>
              </div>
            </div>

            <div class="flex items-start space-x-3">
              <div class="w-6 h-6 bg-green-100 text-green-600 rounded-full flex items-center justify-center flex-shrink-0">
                <svg class="w-3 h-3" fill="currentColor" viewBox="0 0 20 20">
                  <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
                </svg>
              </div>
              <div>
                <h4 class="font-semibold text-gray-900">User Management</h4>
                <p class="text-gray-600 text-sm">Create, modify, and manage user accounts with role-based permissions</p>
              </div>
            </div>

            <div class="flex items-start space-x-3">
              <div class="w-6 h-6 bg-purple-100 text-purple-600 rounded-full flex items-center justify-center flex-shrink-0">
                <svg class="w-3 h-3" fill="currentColor" viewBox="0 0 20 20">
                  <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
                </svg>
              </div>
              <div>
                <h4 class="font-semibold text-gray-900">System Configuration</h4>
                <p class="text-gray-600 text-sm">Configure global settings, languages, and system preferences</p>
              </div>
            </div>

            <div class="flex items-start space-x-3">
              <div class="w-6 h-6 bg-red-100 text-red-600 rounded-full flex items-center justify-center flex-shrink-0">
                <svg class="w-3 h-3" fill="currentColor" viewBox="0 0 20 20">
                  <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
                </svg>
              </div>
              <div>
                <h4 class="font-semibold text-gray-900">Advanced Reporting</h4>
                <p class="text-gray-600 text-sm">Access comprehensive analytics and generate detailed system reports</p>
              </div>
            </div>
          </div>
        </div>

        <div class="space-y-6">
          <h3 class="text-2xl font-semibold text-gray-900">Key Responsibilities</h3>

          <div class="card-luxury">
            <h4 class="font-semibold text-gray-900 mb-3 flex items-center">
              <svg class="w-5 h-5 text-blue-600 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197m13.5-9a2.5 2.5 0 11-5 0 2.5 2.5 0 015 0z"/>
              </svg>
              User Account Management
            </h4>
            <ul class="space-y-1 text-gray-600 text-sm">
              <li>• Create and manage user accounts</li>
              <li>• Assign property-specific permissions</li>
              <li>• Configure user roles and access levels</li>
              <li>• Monitor user activity and sessions</li>
            </ul>
          </div>

          <div class="card-luxury">
            <h4 class="font-semibold text-gray-900 mb-3 flex items-center">
              <svg class="w-5 h-5 text-green-600 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"/>
              </svg>
              Property & Room Administration
            </h4>
            <ul class="space-y-1 text-gray-600 text-sm">
              <li>• Add and configure new properties</li>
              <li>• Manage room assignments and settings</li>
              <li>• Configure guest access permissions</li>
              <li>• Maintain property information accuracy</li>
            </ul>
          </div>

          <div class="card-luxury">
            <h4 class="font-semibold text-gray-900 mb-3 flex items-center">
              <svg class="w-5 h-5 text-purple-600 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"/>
              </svg>
              System Monitoring
            </h4>
            <ul class="space-y-1 text-gray-600 text-sm">
              <li>• Monitor system performance and health</li>
              <li>• Review visitor patterns and analytics</li>
              <li>• Generate compliance and audit reports</li>
              <li>• Troubleshoot system issues</li>
            </ul>
          </div>
        </div>
      </div>

      <!-- Permission Levels -->
      <div class="bg-gradient-to-r from-gray-50 to-blue-50 rounded-2xl p-8">
        <h3 class="text-2xl font-bold text-gray-900 mb-6">User Permission Levels</h3>
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
          <div class="bg-white rounded-xl p-6 shadow-sm">
            <div class="w-12 h-12 bg-red-100 text-red-600 rounded-lg flex items-center justify-center mb-4">
              <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"/>
              </svg>
            </div>
            <h4 class="font-semibold text-gray-900 mb-2">Administrator</h4>
            <p class="text-gray-600 text-sm mb-3">Full system access with all permissions</p>
            <ul class="text-xs text-gray-500 space-y-1">
              <li>✓ Global data access</li>
              <li>✓ User management</li>
              <li>✓ System configuration</li>
              <li>✓ All property management</li>
            </ul>
          </div>

          <div class="bg-white rounded-xl p-6 shadow-sm">
            <div class="w-12 h-12 bg-blue-100 text-blue-600 rounded-lg flex items-center justify-center mb-4">
              <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
              </svg>
            </div>
            <h4 class="font-semibold text-gray-900 mb-2">Property Manager</h4>
            <p class="text-gray-600 text-sm mb-3">Manage assigned properties and guests</p>
            <ul class="text-xs text-gray-500 space-y-1">
              <li>✓ Assigned property access</li>
              <li>✓ Guest check-in/out</li>
              <li>✓ Room management</li>
              <li>✗ User management</li>
            </ul>
          </div>

          <div class="bg-white rounded-xl p-6 shadow-sm">
            <div class="w-12 h-12 bg-green-100 text-green-600 rounded-lg flex items-center justify-center mb-4">
              <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"/>
              </svg>
            </div>
            <h4 class="font-semibold text-gray-900 mb-2">Guest/Public</h4>
            <p class="text-gray-600 text-sm mb-3">Limited access for visitor self-service</p>
            <ul class="text-xs text-gray-500 space-y-1">
              <li>✓ Self check-in/out</li>
              <li>✓ Basic room search</li>
              <li>✗ Data access</li>
              <li>✗ System configuration</li>
            </ul>
          </div>
        </div>
      </div>

      <!-- Common Admin Tasks -->
      <div class="space-y-6">
        <h3 class="text-2xl font-semibold text-gray-900">Common Administrative Tasks</h3>
        
        <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
          <div class="space-y-4">
            <h4 class="text-lg font-semibold text-gray-900">Setting Up New Properties</h4>
            <div class="space-y-3">
              <div class="flex items-start space-x-3">
                <span class="flex-shrink-0 w-6 h-6 bg-blue-600 text-white text-xs rounded-full flex items-center justify-center">1</span>
                <p class="text-gray-600 text-sm">Navigate to Properties section and click "Add New Property"</p>
              </div>
              <div class="flex items-start space-x-3">
                <span class="flex-shrink-0 w-6 h-6 bg-blue-600 text-white text-xs rounded-full flex items-center justify-center">2</span>
                <p class="text-gray-600 text-sm">Enter property details including name, address, and floor count</p>
              </div>
              <div class="flex items-start space-x-3">
                <span class="flex-shrink-0 w-6 h-6 bg-blue-600 text-white text-xs rounded-full flex items-center justify-center">3</span>
                <p class="text-gray-600 text-sm">Add rooms with appropriate guest access permissions</p>
              </div>
              <div class="flex items-start space-x-3">
                <span class="flex-shrink-0 w-6 h-6 bg-blue-600 text-white text-xs rounded-full flex items-center justify-center">4</span>
                <p class="text-gray-600 text-sm">Assign property managers and configure access levels</p>
              </div>
            </div>
          </div>

          <div class="space-y-4">
            <h4 class="text-lg font-semibold text-gray-900">Managing User Accounts</h4>
            <div class="space-y-3">
              <div class="flex items-start space-x-3">
                <span class="flex-shrink-0 w-6 h-6 bg-green-600 text-white text-xs rounded-full flex items-center justify-center">1</span>
                <p class="text-gray-600 text-sm">Access Users section from the admin dashboard</p>
              </div>
              <div class="flex items-start space-x-3">
                <span class="flex-shrink-0 w-6 h-6 bg-green-600 text-white text-xs rounded-full flex items-center justify-center">2</span>
                <p class="text-gray-600 text-sm">Create new user accounts with email and initial password</p>
              </div>
              <div class="flex items-start space-x-3">
                <span class="flex-shrink-0 w-6 h-6 bg-green-600 text-white text-xs rounded-full flex items-center justify-center">3</span>
                <p class="text-gray-600 text-sm">Assign appropriate roles (Admin or Property Manager)</p>
              </div>
              <div class="flex items-start space-x-3">
                <span class="flex-shrink-0 w-6 h-6 bg-green-600 text-white text-xs rounded-full flex items-center justify-center">4</span>
                <p class="text-gray-600 text-sm">Configure property assignments and language preferences</p>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Troubleshooting -->
      <div class="bg-yellow-50 rounded-2xl p-8">
        <h3 class="text-xl font-semibold text-gray-900 mb-4 flex items-center">
          <svg class="w-5 h-5 text-yellow-600 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-2.5L13.732 4c-.77-.833-1.964-.833-2.732 0L3.732 16.5c-.77.833.192 2.5 1.732 2.5z"/>
          </svg>
          Common Issues & Solutions
        </h3>
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div>
            <h4 class="font-medium text-gray-900 mb-2">🔒 User Access Issues</h4>
            <ul class="text-sm text-gray-600 space-y-1">
              <li>• Verify user has correct property assignments</li>
              <li>• Check admin role status for global access</li>
              <li>• Ensure user account is confirmed and active</li>
              <li>• Review room-level guest access permissions</li>
            </ul>
          </div>
          <div>
            <h4 class="font-medium text-gray-900 mb-2">📊 Data Synchronization</h4>
            <ul class="text-sm text-gray-600 space-y-1">
              <li>• Refresh dashboard to see latest visitor status</li>
              <li>• Verify database connections and health</li>
              <li>• Check for pending system updates</li>
              <li>• Review error logs for sync failures</li>
            </ul>
          </div>
        </div>
      </div>
    </div>
    """
  end
end