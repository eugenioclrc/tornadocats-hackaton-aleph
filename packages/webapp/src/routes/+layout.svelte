<script lang="ts">
	import '../app.css';
	let { children } = $props();

	import {init } from '../lib/stores';
	import { init as initZama } from '../lib/fhevmjs';

	import { onMount } from 'svelte';


	onMount(async () => {
		await init();
		await initZama();
	});
</script>

{@render children()}
