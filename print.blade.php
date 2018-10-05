<!doctype html>
<html lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>Assigned to {{ $show_user->present()->fullName() }}</title>
    <style>
        body {
            font-family: "Consolas", sans-serif;
			font-size: 10px;
        }
        table.inventory {
            border: solid #000;
            border-width: 1px 1px 1px 1px;
            width: 100%;
        }

        @page {
            size: letter;
        }
        table.inventory th, table.inventory td {
            border: solid #000;
            border-width: 0 1px 1px 0;
            padding: 3px;
            font-size: 10px;
        }
		
		.footer {
			position: fixed;
			left: 0;
			bottom: 0;
			width: 100%;
			background-color: white;
			color: black;
			text-align: right;
		}
    </style>
</head>
<body>

<p align="center">
	<b>
	{COMPANY NAME HERE}
		<br>
	IT EQUIPMENT ISSUE RECEIPT (EIR)
	</b>
</p>
<b> 
	Employee ID: {{ $show_user->employee_num }} 
</b>
@if ($assets->count() > 0)
    @php
        $counter = 1;
    @endphp
    <table class="inventory">
        <thead>
            <tr>
                <th style="width: 20px;"></th>
                <th style="width: 10%;">Asset Tag</th>
                <th style="width: 10%;">Category</th>
				<th style="width: 10%;">Manufacturer</th>
                <th style="width: 10%;">Model</th>
				<th style="width: 10%;">Model Number</th>
                <th style="width: 10%;">Serial</th>
				<th style="width: 30%;">Condition</th>
                <th style="width: 10%;">Checked Out</th>
            </tr>
        </thead>

    @foreach ($assets as $asset)
		@if (($asset->model) && ($asset->model->fieldset))
			@foreach($asset->model->fieldset->fields as $field)
        <tr>
            <td>{{ $counter }}</td>
            <td>{{ $asset->asset_tag }}</td>
            <td>{{ $asset->model->category->name }}</td>
			<td>{{ $asset->model->manufacturer->name}}</td>
            <td>{{ $asset->model->name }}</td>
			<td>{{ $asset->model->model_number }}</td>
            <td>{{ $asset->serial }}</td>
			<td>{{ $asset->{$field->db_column_name()} }}</td>
            <td>{{ $asset->last_checkout }}</td>
        </tr>
		@endforeach
	@endif
            @php
                $counter++
            @endphp
    @endforeach
    </table>
@endif

@if ($accessories->count() > 0)
    <br><br>
    <table class="inventory">
        <thead>
        <tr>
            <th colspan="4">{{ trans('general.accessories') }}</th>
        </tr>
        </thead>
        <thead>
            <tr>
                <th style="width: 20px;"></th>
                <th style="width: 40%;">Name</th>
                <th style="width: 50%;">Category</th>
                <th style="width: 10%;">Checked Out</th>
            </tr>
        </thead>
        @php
            $acounter = 1;
        @endphp

        @foreach ($accessories as $accessory)

            <tr>
                <td>{{ $acounter }}</td>
                <td>{{ ($accessory->manufacturer) ? $accessory->manufacturer->name : '' }} {{ $accessory->name }} {{ $accessory->model_number }}</td>
                <td>{{ $accessory->category->name }}</td>
                <td>{{  $accessory->assetlog->first()->created_at }}</td>
            </tr>
            @php
                $acounter++
            @endphp
        @endforeach
    </table>
@endif

<p>
	<b>CUSTOMER SIGNATURE</b>
	<br>
	By signing this I acknowledge receipt of the item(s) listed on this page and accept custodial responsibility for it/them. The condition(s) described above is/are accurate. I am responsible for the protection of this/these company asset(s) and will immediately report any loss, damage, or abuse, whether intentional or unintentional, to {NAME HERE}.
</p>
<p>
	Signature:_________________________
		<br>
	Name: {{ $show_user->present()->fullName() }}
		<br>
	Title: {{ $show_user->jobtitle }}
		<br>
	Email: {{ $show_user->present()->email }}
		<br>
	Phone: {{ $show_user->phone }}
		<br>
	Office: {{ $show_user->location->name }}
</p>
<hr>		
<p>
	<b>EQUIPMENT CONTROL OFFICER SIGNATURE</b>
		<br>
	This section to be completed upon return. The item(s) listed above has/have been turned-in.
</p>
<p>
	Signature:_________________________
		<br>
	Name: {{ Auth::user()->first_name }} {{ Auth::user()->last_name }}
		<br>
	Title: {{ Auth::user()->jobtitle }}
		<br>
	Email: {{ Auth::user()->email }}
		<br>
	Phone: {{ Auth::user()->phone }}
		<br>
	Office: {{ Auth::user()->location->name }}
</p>
<hr>
<b>Retain a copy for your records. A signed copy of any turn-in actions should be provided to you when the equipment is returned, replaced, or taken out of production.</b>
<div class="footer">
  <div>{FORM_NUM}</div>
  <div>{REV_DATE}
  <div>All other editions are obsolete</div> 
</div>	
</p>
</body>
</html>