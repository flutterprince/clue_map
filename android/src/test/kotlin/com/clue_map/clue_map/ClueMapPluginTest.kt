package com.clue_map.clue_map

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlin.test.Test
import org.mockito.Mockito

internal class ClueMapPluginTest {
    @Test
    fun onMethodCall_getPlatformVersion_returnsExpectedValue() {
        val plugin = ClueMapPlugin()
        val call = MethodCall("getPlatformVersion", null)
        val mockResult = Mockito.mock(MethodChannel.Result::class.java)
        plugin.onMethodCall(call, mockResult)
        Mockito.verify(mockResult).success("Android " + android.os.Build.VERSION.RELEASE)
    }
}
