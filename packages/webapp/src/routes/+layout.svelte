<script lang="ts">
	import '../app.css';
	let { children } = $props();

	import Buffer from 'buffer'; 
	import {init } from '../lib/stores';
	import { init as initZama } from '../lib/fhevmjs';

	import { onMount } from 'svelte';


	onMount(async () => {
		window.Buffer = Buffer;
		await init();
		await initZama();
	});
</script>

{@render children()}
